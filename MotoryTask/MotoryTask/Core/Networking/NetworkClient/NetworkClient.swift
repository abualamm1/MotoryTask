//
//  NetworkClient.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import Foundation
import RxSwift


struct APIError: Error, Equatable {
    let statusCode: Int?
    let message: String
    var errorDescription: String? { message }
}

protocol NetworkClientType {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> Single<T>
}

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

            var components = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false)!
            components.path = endpoint.path
            components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

            guard let url = components.url else {
                single(.failure(APIError(statusCode: nil, message: "Invalid URL components")))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue

            // Unsplash auth
            request.setValue("Client-ID \(self.accessKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let task = self.session.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    single(.failure(APIError(statusCode: nil, message: error.localizedDescription)))
                    return
                }
                guard let http = response as? HTTPURLResponse else {
                    single(.failure(APIError(statusCode: nil, message: "No HTTP response")))
                    return
                }
                
                
                if let data = data {
                    let bodyString = String(data: data, encoding: .utf8) ?? "<non-UTF8 data>"
                    print("""
                    Body:
                    \(bodyString)
                    """)
                }

                guard (200...299).contains(http.statusCode), let data = data else {
                    let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                    print("HTTP \(http.statusCode) \(url.absoluteString)\n\(body)")
                    single(.failure(APIError(statusCode: http.statusCode, message: body.isEmpty ? "HTTP \(http.statusCode)" : body)))
                    return
                }
                do {
                    let decoded = try self.decoder.decode(T.self, from: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(APIError(statusCode: http.statusCode, message: "Decoding error: \(error)")))
                }
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}



