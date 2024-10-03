//
//  File.swift
//  EasyNetworking
//
//  Created by riakhin on 03.10.2024.
//

import Foundation

public enum Result<Value: Decodable & Sendable>: Sendable {
    case success(Value)
    case failure(NetworkError)
}
