//
//  NetworkManagerTraining.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 17/05/24.
//

import Foundation

enum HTTPMethodTraing: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
}

enum HTTPScheneTraing: String {
    case https
    case http
}

protocol APITraining {
    var scheme: HTTPScheneTraing  { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
}

final class NetworkManagerTraining {
    static func createURLComponents(endpoint: APITraining) -> URLComponents? {
        var components = URLComponents()
        components.queryItems = endpoint.parameters
        components.path = endpoint.path
        components.host = endpoint.baseURL
        components.scheme = endpoint.scheme.rawValue
        return components
    }
    
    static func createURLRequest(url: URL, endpoint: APITraining) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        for header in endpoint.headers {
            request.setValue(header.key, forHTTPHeaderField: header.value)
        }
        
        return request
    }
    
    static func request<T: Decodable> (
        endpoint: APITraining,
        completion: @escaping ((Result<T, Error>)->Void)
    ) {
        
        guard let url = createURLComponents(endpoint: endpoint)?.url,
              let request = createURLRequest(url: url, endpoint: endpoint) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            
            if let error {
                let err = NSError(domain: error.localizedDescription, code: 500)
                completion(.failure(err))
            }
            
            guard response != nil, let data = data else {
                return
            }
            
            if let dataObject = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(dataObject))
            } else {
                let err = NSError(domain: "Failed Parsing", code: 202)
                completion(.failure(err))
            }
            
        }.resume()
        
    }

}
