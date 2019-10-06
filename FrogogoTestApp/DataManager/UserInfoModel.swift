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
    
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let avatarURL: String?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, avatarURL, updatedAt
    }
}
