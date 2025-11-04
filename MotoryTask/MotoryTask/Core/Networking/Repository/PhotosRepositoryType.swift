//
//  PhotosRepositoryType.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import RxSwift
import Foundation

protocol PhotosRepositoryType {
    func listPhotos(page: Int, perPage: Int) -> Single<[photoModel]>
    func searchPhotos(query: String, page: Int, perPage: Int) -> Single<SearchPhotosResponse>
}

final class PhotosRepository: PhotosRepositoryType {
    private let client: NetworkClientType
    init(client: NetworkClientType = NetworkClient()) {
        self.client = client
    }

    func listPhotos(page: Int, perPage: Int) -> Single<[photoModel]> {
        client.request(UnsplashEndpoint.listPhotos(page: page, perPage: perPage))
    }

    func searchPhotos(query: String, page: Int, perPage: Int) -> Single<SearchPhotosResponse> {
        client.request(UnsplashEndpoint.searchPhotos(query: query, page: page, perPage: perPage))
    }
}
