//
//  UnsplashEndpoint.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import Foundation

enum UnsplashEndpoint: APIEndpoint {
    case listPhotos(page: Int, perPage: Int)
    case searchPhotos(query: String, page: Int, perPage: Int)

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
        case let .listPhotos(page, perPage):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        case let .searchPhotos(query, page, perPage):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        }
    }
}
