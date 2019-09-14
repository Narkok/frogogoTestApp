//
//  UsersListViewModel.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import Foundation
import RxCocoa

class UsersListViewModel {
    
    let dataManager = UsersDataManager()
    
    // Выходы в контроллер
    let users: Driver<[UserInfo]>
    let error: Driver<String>
    let isLoading: Driver<Bool>
    let loadIsFinished: Driver<Void>
    
    init() {
        // Список пользователей
        let data = dataManager.result
            .map { $0.element ?? [] }
        
        // Состояние загрузки
        let isLoading = dataManager.result
            .map { _ in false }
            .startWith(true)
        
        // Загрузка данных завершена
        let loadIsFinished = dataManager.result
            .map { _ in () }
        
        // Текст ошибки
        let errorText = dataManager.result
            .map { $0.error as? UsersDataManagerError }
            .filter { $0 != nil }
            .map { $0!.text }
        
        self.error = errorText.asDriver(onErrorJustReturn: "")
        self.users = data.asDriver(onErrorJustReturn: [])
        self.isLoading = isLoading.asDriver(onErrorJustReturn: false)
        self.loadIsFinished = loadIsFinished.asDriver(onErrorJustReturn: ())
        
        dataManager.getData()
    }
}
