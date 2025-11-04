//
//  photoModel.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import Foundation

class photoModel: Codable {
    var id: Int?
    var description: String?
    var likedByUser: Bool?
    var urls: URLsModel?
    var user: UserModel?
    
    init(id: Int? = nil, description: String? = nil, likedByUser: Bool? = nil, urls: URLsModel? = nil) {
        self.id = id
        self.description = description
        self.urls = urls
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }
}

class URLsModel: Codable {
    var regular: String?
    
    init(regular: String? = nil) {
        self.regular = regular
    }
    
    enum CodingKeys: String, CodingKey {
        case regular
    }
}


class UserModel: Codable {
    var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
