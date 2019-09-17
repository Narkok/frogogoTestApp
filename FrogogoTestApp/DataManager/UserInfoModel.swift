//
//  UserInfoModel.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 16/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import Foundation

/// Модель структуры пользователя
struct UserInfo: Codable, Comparable {
    
    /// Сравнение для сортировки пользователей по дате обновления
    static func < (lhs: UserInfo, rhs: UserInfo) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss' 'zzz"
        guard let dateL = dateFormatter.date(from: lhs.updatedAt) else { return true }
        guard let dateR = dateFormatter.date(from: rhs.updatedAt) else { return true }
        return dateL < dateR
    }
    
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let avatarUrl: String?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case avatarUrl = "avatar_url"
        case updatedAt = "updated_at"
    }
}
