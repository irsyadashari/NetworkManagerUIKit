//
//  GooglePlacesAPI.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 21/04/24.
//

import Foundation

enum GooglePlacesAPI: API {
    case getNearbyPlaces(
        searchText: String?,
        latitude: Double,
        longitude: Double
    )
    case getSumthing(headers: [String: String])
    
    var scheme: HTTPScheme {
        switch self {
        case .getNearbyPlaces:
            return .https
        case .getSumthing(headers: _):
            return .https
        }
    }
    
    var baseURL: String {
        switch self {
        case .getNearbyPlaces:
            return "maps.googleapis.com"
        case .getSumthing(headers: _):
            return "maps.googleapis.com"
        }
    }
    
    var path: String {
        switch self {
        case .getNearbyPlaces:
            return "/maps/api/place/nearbysearch/json"
        case .getSumthing(headers: _):
            return "/maps/api/place/nearbysearch/json"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getNearbyPlaces(let query, let latitude, let longitude):
            var params = [
                URLQueryItem(name: "key", value: "GooglePlacesAPI.key"),
                URLQueryItem(name: "language",
                             value: Locale.current.language.languageCode?.identifier),
                URLQueryItem(name: "type", value: "restaurant"),
                URLQueryItem(name: "radius", value: "6500"),
                URLQueryItem(name: "location",
                             value: "\(latitude),\(longitude)")
            ]
            if let query = query {
                params.append(URLQueryItem(name: "keyword", value: query))
            }
            return params
        case .getSumthing(headers: _):
            return []
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getNearbyPlaces(searchText: _, latitude: _, longitude: _):
            return [:]
        case .getSumthing(let headers):
            return headers
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNearbyPlaces:
            return .get
        case .getSumthing(_):
            return .get
        }
    }
}
