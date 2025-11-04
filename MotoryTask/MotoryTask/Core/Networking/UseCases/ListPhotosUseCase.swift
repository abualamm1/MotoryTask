//
//  ListPhotosUseCase.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import Foundation
import RxSwift

struct ListPhotosUseCase {
    let repo: PhotosRepositoryType
    func execute(page: Int, perPage: Int) -> Single<[photoModel]> {
        repo.listPhotos(page: page, perPage: perPage)
    }
    
    struct SearchPhotosUseCase {
        let repo: PhotosRepositoryType
        func execute(query: String, page: Int, perPage: Int) -> Single<SearchPhotosResponse> {
            repo.searchPhotos(query: query, page: page, perPage: perPage)
        }
    }
}
