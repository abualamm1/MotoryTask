//
//  PhotosRepositoryType.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import RxSwift
import Foundation

/// Represents an event emitted during a response lifecycle.
enum ResponseEvent<T> {
    case next(T)
    case error(Error)
    case completed
}

/// Abstraction for photo data operations.
protocol PhotosRepositoryType {
    func listPhotos() -> Single<[PhotoModel]>
    func searchPhotos(query: String) -> Single<SearchPhotosResponse>
}

/// Repository that fetches photo data from the network.
final class PhotosRepository: PhotosRepositoryType {
    private let client: NetworkClientType

    init(client: NetworkClientType = NetworkClient()) {
        self.client = client
    }

    func listPhotos() -> Single<[PhotoModel]> {
        client.request(UnsplashEndpoint.listPhotos)
    }

    func searchPhotos(query: String) -> Single<SearchPhotosResponse> {
        client.request(UnsplashEndpoint.searchPhotos(query: query))
    }
}
