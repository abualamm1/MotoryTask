//
//  photoModel.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import Foundation

final class PhotoModel: Codable {
    var id: String?
    var altDescription: String?
    var likedByUser: Bool = false
    var urls: URLsModel?
    var user: UserModel?

    enum CodingKeys: String, CodingKey {
        case id
        case altDescription = "alt_description"
        case likedByUser = "liked_by_user"
        case urls, user
    }
    
    init(id: String? = nil, altDescription: String? = nil, likedByUser: Bool, urls: URLsModel? = nil, user: UserModel? = nil) {
        self.id = id
        self.altDescription = altDescription
        self.likedByUser = likedByUser
        self.urls = urls
        self.user = user
    }
}

final class URLsModel: Codable {
    var full: String?
}

final class UserModel: Codable {
    var username: String?
}


class SearchPhotosResponse: Codable {
    let results: [PhotoModel]?
    
    init(results: [PhotoModel]? = nil) {
        self.results = results
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

