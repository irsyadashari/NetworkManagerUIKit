//
//  TestAPI.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 21/04/24.
//

import Foundation

enum TestAPI: API {
    case get(Void)
    
    var scheme: HTTPScheme {
        return .https
    }
    
    var baseURL: String {
        return "6629c92c67df268010a199ab.mockapi.io"
    }
    
    var path: String {
        switch self {
        case .get:
            return "/api/irsyadmock/date"
        }
    }
    
    var parameters: [URLQueryItem] {
        return []
    }
    
    var headers: [String: String] {
        return ["Tests":"tst"]
    }
    
    var method: HTTPMethod {
        return .get
    }
}
