//
//  File.swift
//  EasyNetworking
//
//  Created by riakhin on 02.10.2024.
//

import Foundation

protocol NetworkSession {
    func get(request: URLRequest, completion: @escaping @Sendable(Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func get(request: URLRequest, completion: @escaping @Sendable(Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request, completionHandler: completion).resume()
    }
}

public class NetworkSessionManager {
    
    internal var session: NetworkSession = URLSession.shared
        
    public init() { }
    
    public func load<T: Decodable>(request: NetworkRequest, completion: @escaping @Sendable(Result<T>) -> Void) {
        
        guard let urlRequest = createUrlRequest(from: request) else {
            completion(.failure(NetworkError.badUrlRequest))
            return
        }
        
        session.get(request: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseEmpty))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataEmpty))
                return
            }
            
            switch response.statusCode {
            case 200..<299:
                let result = try? JSONDecoder().decode(T.self, from: data)
                let response = result.map(Result<T>.success) ?? Result.failure(NetworkError.unknownError)
                completion(response)
            default:
                break
            }
        }
    }
    
    
    func createUrlRequest(from request: NetworkRequest) -> URLRequest? {
        guard let url = URL(string: request.url) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
}
