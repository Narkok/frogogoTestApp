//
//  UsersAPIRequest.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import Moya

fileprivate let testBaseURL = URL(string: "https://frogogo-test.herokuapp.com")!

enum UsersAPIRequest {
    case get
    case post(data: UserInfo)
}


extension UsersAPIRequest: TargetType {
    
    var task: Task {
        switch self {
        case .get:
            return .requestPlain
    
        case .post(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var baseURL: URL { return testBaseURL }
    
    var path: String { return "users.json" }
    
    var method: Moya.Method {
        switch self {
        case .get:
            return .get
            
        case .post:
            return .post
        }
    }
    
    var sampleData: Data { return "{}".data(using: .utf8)! }
    
    var headers: [String : String]? { return ["Content-Type": "application/json"] }
    
}
