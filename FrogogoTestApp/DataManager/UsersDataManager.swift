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
    
    let result = PublishRelay<Event<[UserInfo]>>()
    
    static private let provider = MoyaProvider<UsersAPIRequest>()
    
    
    /// Отправка GET запроса
    func getData() {
        UsersDataManager.provider.request(.get, completion: { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode([UserInfo].self, from: response.data)
                    self?.result.accept(.next(data))
                }
                catch { self?.result.accept(.error(UsersDataManagerError(text: "Ошибка при парсинге данных"))) }
            case .failure(_): self?.result.accept(.error(UsersDataManagerError(text: "Ошибка при запросе данных")))
            }
        })
    }
    
    /// Отправка POST запроса
    func post(_ data: UserInfo) {
        UsersDataManager.provider.request(.post(data: data), completion: { [weak self] result in
            switch result {
            case .success: self?.result.accept(.completed)
            case .failure: self?.result.accept(.error(UsersDataManagerError(text: "Ошибка при оправке запроса")))
            }
        })
    }
    
    /// Отправка PATCH запроса
    func patch(_ data: UserInfo) {
        UsersDataManager.provider.request(.patch(data: data), completion: { [weak self] result in
            switch result {
            case .success: self?.result.accept(.completed)
            case .failure: self?.result.accept(.error(UsersDataManagerError(text: "Ошибка при оправке запроса")))
            }
        })
    }
}


struct UsersDataManagerError: Error {
    let text: String
}
