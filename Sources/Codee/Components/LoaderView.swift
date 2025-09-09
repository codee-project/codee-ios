//
//  LoaderView.swift
//  Codee
//
//  Created by Eryk on 30/07/2025.
//

import SwiftUI

public extension View {
    func loader(_ isLoading: Binding<Bool>) -> some View {
        ZStack {
            self
                .disabled(isLoading.wrappedValue)
            
            if isLoading.wrappedValue {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    LoaderView()
                }
            }
        }
    }
}

public struct LoaderView: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1
    
    public var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 60, height: 60)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    self.scale = 1.4
                    self.opacity = 1
                }
            }
    }
}
