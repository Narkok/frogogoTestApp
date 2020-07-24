//
//  UserDetailsViewModel.swift
//  UsersAPIfrontendApp
//
//  Created by Narek Stepanyan on 15/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import RxCocoa
import RxSwift

class UserDetailsViewModel {
    
    private static let dataManager = UsersDataManager()
    
    /// Входы из контроллера
    let createButton = PublishRelay<Void>()
    let avatarURL = PublishRelay<(isValid: Bool, string: String)>()
    let firstName = PublishRelay<(isValid: Bool, string: String)>()
    let lastName = PublishRelay<(isValid: Bool, string: String)>()
    let email = PublishRelay<(isValid: Bool, string: String)>()
    
    /// Выходы в контроллер
    let requestResult: Driver<Bool>
    let blockScreen: Driver<Void>
    let buttonIsActive: Driver<Bool>
    
    enum RequestType {
        case post
        case patch
    }
    
    init(for requestType: RequestType, userID: String?) {
        
        /// Все данные валидны
        let isValid = Observable.combineLatest(firstName, lastName, email, avatarURL)
            .filter { $0.0.isValid && $0.1.isValid && $0.2.isValid }
            .map { (firstName: $0.0.string, lastName: $0.1.string, email: $0.2.string, avatarURL: $0.3.string) }
        
        /// Активация кнопки 'Создать'
        let buttonIsActive = Observable.combineLatest(firstName, lastName, email)
            .map { $0.0.isValid && $0.1.isValid && $0.2.isValid }
            .asDriver(onErrorJustReturn: true)
        
        /// Блокировка экрана
        let blockScreen = createButton
            .withLatestFrom(isValid)
            .map {_ in ()}
            .asDriver(onErrorJustReturn: ())
        
        /// Результат отправки запроса с данными нового пользователя
        let requestResult = createButton.withLatestFrom(isValid)
            .map { UserInfo(id: userID ?? "",
                            firstName: $0.firstName,
                            lastName: $0.lastName,
                            email: $0.email,
                            avatarURL: $0.avatarURL,
                            updatedAt: "")
            }
            .flatMapLatest { data -> Observable<Event<Bool>> in
                if requestType == .post  { return UserDetailsViewModel.dataManager.post(data) }
                if requestType == .patch { return UserDetailsViewModel.dataManager.patch(data) }
                return .never()
            }
            .map { $0.element ?? false }
            .share(replay: 1)
            .asDriver(onErrorJustReturn: false)
        
        self.requestResult = requestResult
        self.blockScreen = blockScreen
        self.buttonIsActive = buttonIsActive
    }
}
