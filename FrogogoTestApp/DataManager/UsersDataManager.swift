//
//  UsersDataManager.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya


class UsersDataManager {
    
    let result = PublishRelay<Event<[RequestData.User]>>()
    
    static private let provider = MoyaProvider<UsersAPIRequest>()
    
    func getData() {
        
        UsersDataManager.provider.request(.get, completion: { [weak self] result in
            
            switch result {
                
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode([RequestData.User].self, from: response.data)
                    self?.result.accept(.next(data))
                }
                catch {
                    self?.result.accept(.error(UsersDataManagerError(text: "Ошибка при парсинге данных")))
                }
                
            case .failure(_):
                self?.result.accept(.error(UsersDataManagerError(text: "Ошибка при запросе данных")))

            }
        })
    }
    
    struct UsersDataManagerError: Error {
        let text: String
    }
    
}



struct RequestData: Codable {
    
    struct User: Codable {
        let id: Int
        let firstName: String
        let lastName: String
        let email: String
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case firstName = "first_name"
            case lastName = "last_name"
            case email = "email"
            case url = "url"
        }
        
    }
}
