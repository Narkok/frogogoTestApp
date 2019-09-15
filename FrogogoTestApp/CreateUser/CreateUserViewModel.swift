//
//  CreateUserViewModel.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 15/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import RxCocoa
import RxSwift

class CreateUserViewModel {
    
    let dataManager = UsersDataManager()
    
    /// Входы из контроллера
    let createButton = PublishRelay<Void>()
    let firstName = PublishRelay<(isValid: Bool, string: String)>()
    let lastName = PublishRelay<(isValid: Bool, string: String)>()
    let email = PublishRelay<(isValid: Bool, string: String)>()
    
    var requestResult: Driver<Event<[UserInfo]>>!
    
    init() {
        // Все данные валидны
        let isValid = Observable.combineLatest(firstName, lastName, email)
            .filter { $0.0.isValid && $0.1.isValid && $0.2.isValid }
            .map { (firstName: $0.0.string, lastName: $0.1.string, email: $0.2.string ) }
        
        let requestResult = createButton.withLatestFrom(isValid)
            .map { UserInfo(id: 0,
                            firstName: $0.firstName,
                            lastName: $0.lastName,
                            email: $0.email,
                            avatarUrl: nil) }
            .flatMapLatest { [weak self] data -> Observable<Event<[UserInfo]>> in
                guard let self = self else { return .error(UsersDataManagerError(text: "Ошибка при отправке данных")) }
                self.dataManager.postData(data: data)
                return self.dataManager.result.asObservable()
            }.share(replay: 1, scope: .forever)
            .asDriver(onErrorJustReturn: .error(UsersDataManagerError(text: "Ошибка")))
        
        self.requestResult = requestResult
    }
}
