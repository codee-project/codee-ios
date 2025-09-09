//
//  APIClient.swift
//  Codee
//
//  Created by Eryk on 19/03/2025.
//

import Foundation

public protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

public class APIClient: APIClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let request = prepareRequest(for: endpoint) else {
            throw NetworkError.invalidRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        logAPIResponse(request: request, response: httpResponse, data: data)
        
        if !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.responseError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ DECODING ERROR:")
            print("   Error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
    
    private func logAPIResponse(request: URLRequest, response: HTTPURLResponse, data: Data) {
        let url = request.url?.absoluteString ?? "Unknown URL"
        let method = request.httpMethod ?? "GET"
        let statusCode = response.statusCode
        
        // Emoji dla statusu
        let statusEmoji = getStatusEmoji(for: statusCode)
        
        print("\n" + String(repeating: "=", count: 80))
        print("🌐 API REQUEST")
        print(String(repeating: "-", count: 80))
        print("📍 URL: \(url)")
        print("🔧 Method: \(method)")
        print("\(statusEmoji) Status: \(statusCode)")
        
        // Formatowanie JSON response
        if let jsonString = formatJSONData(data) {
            print("\n📦 RESPONSE:")
            print(String(repeating: "-", count: 40))
            print(jsonString)
        } else if let rawString = String(data: data, encoding: .utf8) {
            print("\n📦 RAW RESPONSE:")
            print(String(repeating: "-", count: 40))
            print(rawString)
        }
        
        print(String(repeating: "=", count: 80) + "\n")
    }
    
    private func getStatusEmoji(for statusCode: Int) -> String {
        switch statusCode {
        case 200...299: return "✅"
        case 300...399: return "🔄"
        case 400...499: return "⚠️"
        case 500...599: return "❌"
        default: return "❓"
        }
    }
    
    private func formatJSONData(_ data: Data) -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                return addLineNumbers(to: prettyString)
            }
        } catch {
            // Jeśli nie można sparsować jako JSON, zwróć nil
        }
        return nil
    }
    
    private func addLineNumbers(to text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
        let maxLineNumberWidth = String(lines.count).count
        
        return lines.enumerated().map { index, line in
            let lineNumber = String(format: "%\(maxLineNumberWidth)d", index + 1)
            return "  \(lineNumber) │ \(line)"
        }.joined(separator: "\n")
    }
    
    private func prepareRequest(for endpoint: APIEndpoint) -> URLRequest? {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Dodaj nagłówki
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        endpoint.headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Dodaj parametry do body jeśli istnieją
        if let parameters = endpoint.parameters, endpoint.method != .get {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                return nil
            }
        }
        
        // Dodaj parametry do URL jeśli to GET
        if let parameters = endpoint.parameters, endpoint.method == .get {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            request.url = components?.url
        }
        
        return request
    }
}

// MARK: - Debug Helper Extension
public extension APIClient {
    /// Włącz szczegółowe logowanie dla debugowania
    static let isVerboseLoggingEnabled = true
    
    /// Loguj tylko błędy (dla produkcji)
    static let logErrorsOnly = false
}

public extension APIClient {
    func authorizedRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let token = UserDefaults.standard.string(forKey: "jwt_token") else {
            throw APIError.invalidResponse
        }
        
        // Dodaj Authorization header
        var authorizedEndpoint = endpoint
        var headers = endpoint.headers ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        
        authorizedEndpoint = APIEndpoint(
            path: endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            headers: headers
        )
        
        return try await request(authorizedEndpoint)
    }
}

public enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
