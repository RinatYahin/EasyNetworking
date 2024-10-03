//
//  File.swift
//  EasyNetworking
//
//  Created by riakhin on 03.10.2024.
//

import Foundation

public enum NetworkError: Error {    
    case decodeError(String)
    case badUrlRequest
    case responseEmpty
    case dataEmpty
    case unknownError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodeError(let description):
            return "Decode model error \(description)"
        case .badUrlRequest:
            return "Bad url request"
        case .responseEmpty:
            return "Response is empty"
        case .dataEmpty:
            return "Response data is empty"
        case .unknownError:
            return "Unknown error"
        }
    }
}
