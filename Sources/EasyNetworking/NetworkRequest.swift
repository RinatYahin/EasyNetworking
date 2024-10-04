//
//  File.swift
//  EasyNetworking
//
//  Created by riakhin on 03.10.2024.
//

import Foundation

public protocol NetworkRequest {
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String: Any]? { get }
}

extension NetworkRequest {
    public var headers: [String: Any]? {
        return [:]
    }
}
