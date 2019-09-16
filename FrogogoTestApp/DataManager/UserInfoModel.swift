//
//  UserInfoModel.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 16/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//


/// Модель структуры пользователя
struct UserInfo: Codable, Comparable {
    static func < (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.id < rhs.id
    }
    
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case avatarUrl = "avatar_url"
    }
}
