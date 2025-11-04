//
//  PhotosRepositoryType.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import RxSwift
import Foundation

enum ResponseEvent<T> {
    case next(T)
    case error(Error)
    case completed
}

protocol PhotosRepositoryType {
    func listPhotos() -> Single<[PhotoModel]>
    func searchPhotos(query: String) -> Single<SearchPhotosResponse>
}

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
