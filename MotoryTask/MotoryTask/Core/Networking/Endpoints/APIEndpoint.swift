//
//  APIEndpoint.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import Foundation

enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE }

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}
