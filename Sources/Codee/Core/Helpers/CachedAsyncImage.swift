//
//  CachedAsyncImage.swift
//  Codee
//
//  Created by Eryk Chrustek on 29/01/2026.
//

import Foundation
import UIKit

public actor ImageCacheManager {
    public static let shared = ImageCacheManager()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let maxCacheSize: Int64 = 1_000_000_000 // 1 GB
    private let cleanupSize: Int64 = 300_000_000    // 300 MB
    
    public  init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        
        // Utwórz folder cache jeśli nie istnieje
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // Pobierz obrazek z cache lub pobierz z URL
    public func getImage(from urlString: String) async -> UIImage? {
        let cacheKey = getCacheKey(from: urlString)
        let fileURL = cacheDirectory.appendingPathComponent(cacheKey)
        
        // Sprawdź czy istnieje w cache
        if fileManager.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            
            // Zaktualizuj datę dostępu
            try? fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: fileURL.path)
            return image
        }
        
        // Pobierz z sieci
        guard let url = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        // Zapisz do cache
        await saveToCache(data: data, key: cacheKey)
        
        return image
    }
    
    private func getCacheKey(from urlString: String) -> String {
        // Prosty hash bazujący na absoluteValue hash'a stringa
        let hash = abs(urlString.hashValue)
        return "\(hash).jpg"
    }
    
    private func saveToCache(data: Data, key: String) async {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        // Sprawdź rozmiar cache przed zapisem
        if await getCurrentCacheSize() > maxCacheSize {
            await cleanup()
        }
        
        try? data.write(to: fileURL)
    }
    
    private func getCurrentCacheSize() async -> Int64 {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        return files.reduce(0) { total, fileURL in
            let size = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
            return total + Int64(size)
        }
    }
    
    private func cleanup() async {
        guard let files = try? fileManager.contentsOfDirectory(
            at: cacheDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey]
        ) else {
            return
        }
        
        // Sortuj pliki po dacie modyfikacji (najstarsze pierwsze)
        let sortedFiles = files.sorted { file1, file2 in
            let date1 = (try? file1.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
            let date2 = (try? file2.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
            return date1 < date2
        }
        
        var deletedSize: Int64 = 0
        
        // Usuń najstarsze pliki aż do osiągnięcia cleanupSize
        for file in sortedFiles {
            guard deletedSize < cleanupSize else { break }
            
            let fileSize = (try? file.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
            try? fileManager.removeItem(at: file)
            deletedSize += Int64(fileSize)
        }
    }
    
    // Wyczyść cały cache
    public func clearCache() async {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}

import CommonCrypto
import SwiftUI

public struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    public let url: URL?
    public let content: (Image) -> Content
    public let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    public init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else {
                placeholder()
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else {
            isLoading = false
            return
        }
        
        if let cachedImage = await ImageCacheManager.shared.getImage(from: url.absoluteString) {
            await MainActor.run {
                self.image = cachedImage
                self.isLoading = false
            }
        } else {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
