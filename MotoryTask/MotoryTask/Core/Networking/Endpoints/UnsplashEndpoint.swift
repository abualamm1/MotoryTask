//
//  UnsplashEndpoint.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import Foundation

enum UnsplashEndpoint: APIEndpoint {
    case listPhotos
    case searchPhotos(query: String)

    var path: String {
        switch self {
        case .listPhotos: return "/photos"
        case .searchPhotos: return "/search/photos"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listPhotos: return .GET
        case .searchPhotos: return .GET
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .listPhotos:
            return [URLQueryItem(name: "per_page", value: "\(20)"),]
        case .searchPhotos(let query):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "per_page", value: "\(20)"),
            ]
        }
    }
}
