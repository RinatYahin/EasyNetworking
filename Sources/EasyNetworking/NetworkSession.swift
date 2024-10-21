//
//  File.swift
//  EasyNetworking
//
//  Created by riakhin on 02.10.2024.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]
internal protocol NetworkSession {
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
    
    public func load<T: Decodable>(urlString: String,
                                   httpMethod: HTTPMethod = .get,
                                   headers: HTTPHeaders = [:],
                                   parameters: Parameters = [:],
                                   completion: @escaping @Sendable(Result<T>) -> Void) {
        
        guard let request = createUrlRequest(from: urlString,
                                             method: httpMethod,
                                             headers: headers,
                                             parameters: parameters) else {
            completion(.failure(NetworkError.badUrlRequest))
            return
        }
        
        session.get(request: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseEmpty))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataEmpty))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString) // Выведет JSON в виде строки
            } else {
                print("Не удалось конвертировать данные в строку")
            }
            
            switch response.statusCode {
            case 200..<299:
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(Result.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(Result.failure(NetworkError.unknownError))
                }

            default:
                break
            }
        }
    }
    
    internal func createUrlRequest(from urlString: String,
                                   method: HTTPMethod,
                                   headers: HTTPHeaders,
                                   parameters: Parameters) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        for (key, value) in headers {
            urlRequest.addValue(key, forHTTPHeaderField: value)
        }
        
        return urlRequest
    }
}
