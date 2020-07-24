//
//  UsersDataManager.swift
//  UsersAPIfrontendApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya


class UsersDataManager {
    
    static private let provider = MoyaProvider<UsersAPIRequest>()
    
    /// GET запрос
    func getData() -> Observable<Event<[UserInfo]>> {
        let resultList = PublishRelay<Event<[UserInfo]>>()
        UsersDataManager.provider.request(.get, completion: { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode([UserInfo].self, from: response.data)
                    resultList.accept(.next(data))
                }
                catch { resultList.accept(.error(UsersDataManagerError(text: "Ошибка при парсинге данных"))) }
            case .failure(_): resultList.accept(.error(UsersDataManagerError(text: "Ошибка при запросе данных")))
            }
        })
        return resultList.asObservable()
    }
    
    /// POST запрос
    func post(_ data: UserInfo) -> Observable<Event<Bool>> {
        let response = PublishRelay<Event<Bool>>()
        UsersDataManager.provider.request(.post(data: data), completion: { result in
            switch result {
            case .success: response.accept(.next(true))
            case .failure: response.accept(.error(UsersDataManagerError(text: "Ошибка при оправке запроса")))
            }
        })
        return response.asObservable()
    }
    
    /// PATCH запрос
    func patch(_ data: UserInfo) -> Observable<Event<Bool>> {
        let response = PublishRelay<Event<Bool>>()
        UsersDataManager.provider.request(.patch(data: data), completion: { result in
            switch result {
            case .success: response.accept(.next(true))
            case .failure: response.accept(.error(UsersDataManagerError(text: "Ошибка при оправке запроса")))
            }
        })
        return response.asObservable()
    }
}


struct UsersDataManagerError: Error {
    let text: String
}
