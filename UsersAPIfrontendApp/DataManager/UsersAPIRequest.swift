//
//  UsersAPIRequest.swift
//  UsersAPIfrontendApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import Moya

private let localhostURL = URL(string: "http://users.342634-cf64550.tmweb.ru")!

enum UsersAPIRequest {
    case get
    case post(data: UserInfo)
    case patch(data: UserInfo)
}


extension UsersAPIRequest: TargetType {
    
    var task: Task {
        switch self {
        case .get: return .requestPlain
        case .post(let data): return .requestJSONEncodable(data)
        case .patch(let data): return .requestJSONEncodable(data)
        }
    }
    
    var baseURL: URL { return localhostURL }
    
    var path: String {
        switch self {
        case .get, .post: return "users"
        case .patch(let data): return "users/\(data.id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .get: return .get
        case .post: return .post
        case .patch: return .patch
        }
    }
    
    var sampleData: Data { return "{}".data(using: .utf8)! }
    
    var headers: [String : String]? { return ["Content-Type": "application/json"] }
    
}
