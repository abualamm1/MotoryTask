//
//  NetworkClient.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import Foundation
import RxSwift


/// Represents an API-related error with optional status code and message.
struct APIError: Error, Equatable {
    let statusCode: Int?
    let message: String
    var errorDescription: String? { message }
}

/// Defines the network client's basic request capability.
protocol NetworkClientType {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> Single<T>
}

/// A lightweight network client using `URLSession`.
/// `Suitable for small or simple projects where Alamofire would be overkill.`
final class NetworkClient: NetworkClientType {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let accessKey: String

    init(baseURL: URL = AppConfig.baseURL,
         accessKey: String = AppConfig.accessKey,
         session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.accessKey = accessKey
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) -> Single<T> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(APIError(statusCode: nil, message: "Deallocated")))
                return Disposables.create()
            }

            // Build URL with path and query parameters
            var components = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false)!
            components.path = endpoint.path
            components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

            guard let url = components.url else {
                single(.failure(APIError(statusCode: nil, message: "Invalid URL components")))
                return Disposables.create()
            }

            // Prepare request
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue

            // Unsplash API authentication headers
            request.setValue("Client-ID \(self.accessKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            // Execute request
            let task = self.session.dataTask(with: request) { data, response, error in
                
                // Network or transport-level error
                if let error = error {
                    single(.failure(APIError(statusCode: nil, message: error.localizedDescription)))
                    return
                }

                // Ensure we have a valid HTTP response
                guard let http = response as? HTTPURLResponse else {
                    single(.failure(APIError(statusCode: nil, message: "No HTTP response")))
                    return
                }

                // Check HTTP status code
                guard (200...299).contains(http.statusCode), let data = data else {
                    let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                    single(.failure(APIError(
                        statusCode: http.statusCode,
                        message: body.isEmpty ? "HTTP \(http.statusCode)" : body
                    )))
                    return
                }

                // Decode response
                do {
                    let decoded = try self.decoder.decode(T.self, from: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(APIError(
                        statusCode: http.statusCode,
                        message: "Decoding error: \(error)"
                    )))
                }
            }

            task.resume()

            // Cancel task if disposed
            return Disposables.create { task.cancel() }
        }
    }
}
