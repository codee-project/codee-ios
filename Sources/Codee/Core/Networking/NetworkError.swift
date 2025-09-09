//
//  NetworkError.swift
//  Codee
//
//  Created by Eryk on 19/03/2025.
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case responseError(statusCode: Int)
    case decodingError(Error)
    case serverError(Error)
    case unknown
}
