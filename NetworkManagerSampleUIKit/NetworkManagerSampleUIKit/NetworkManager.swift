//
//  NetworkManager.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 21/04/24.
//

import Foundation

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum HTTPScheme: String {
    case http
    case https
}

/// The API protocol allows us to separate the task of constructing a URL,
/// its parameters, and HTTP method from the act of executing the URL request
/// and parsing the response.
protocol API {
    /// .http or .https
    var scheme: HTTPScheme { get }
    // Example: "maps.googleapis.com"
    var baseURL: String { get }
    // "/maps/api/place/nearbysearch/"
    var path: String { get }
    // [URLQueryItem(name: "api_key", value: API_KEY)]
    var parameters: [URLQueryItem] { get }
    // [headers]
    var headers: [String: String] { get }
    // "GET"
    var method: HTTPMethod { get }
}

final class NetworkManager {
    /// Builds the relevant URL components from the values specified
    /// in the API.
    private class func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }
    
    private class func buildRequest(url: URL?, endpoint: API) -> URLRequest? {
        if let url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endpoint.method.rawValue
            
            for item in endpoint.headers {
                urlRequest.setValue(item.key, forHTTPHeaderField: item.value)
            }
            print("linecu headers \(endpoint.headers)")
            return urlRequest
        }
        return nil
    }
    /// Executes the HTTP request and will attempt to decode the JSON
    /// response into a Codable object.
    /// - Parameters:
    /// - endpoint: the endpoint to make the HTTP request to
    /// - completion: the JSON response converted to the provided Codable
    /// object when successful or a failure otherwise
    static func request<T: Decodable>(
        endpoint: API,
        completion: @escaping (Result<T, Error>) -> Void)
    {
        let components: URLComponents = buildURL(endpoint: endpoint)
        
        guard let url = components.url,
        let urlRequest = buildRequest(url: url, endpoint: endpoint) else {
            print("URL creation error")
            let error = NSError(
                domain: "com.irsyadashari",
                code: 500,
                userInfo: [ NSLocalizedDescriptionKey: "URL creation error" ]
            )
            completion(.failure(error))
            return
        }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Unknown error \(error)")
                return
            }
            
            guard response != nil, let data = data else {
                print("Data is nil")
                return
            }
            
            if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(responseObject))
            } else {
                let error = NSError(
                    domain: "com.irsyadashari",
                    code: 200,
                    userInfo: [ NSLocalizedDescriptionKey: "Failed to parse JSON into object" ]
                )
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
