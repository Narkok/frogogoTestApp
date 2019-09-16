//
//  UsersListViewModel.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import RxCocoa
import RxSwift

class UsersListViewModel {
    
    private let dataManager = UsersDataManager()
    
    // Выходы в контроллер
    var users: Driver<[UserInfo]>!
    var error: Driver<String>!
    var isLoading: Driver<Bool>!
    var loadIsFinished: Driver<Void>!
    
    // Запрос на обновление
    let loadData = PublishRelay<Void>()
    
    init() {
        // Список пользователей
//        let data = dataManager.result
//            .map { $0.element ?? [] }
        // Отсортировать пожалуйста
        let data = loadData.flatMapLatest { [weak self] () -> PublishRelay<Event<[UserInfo]>> in
            guard let self = self else { return .init() }
            return self.dataManager.getData()
        }.map { $0.element ?? [] }
        
        
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
        
//        dataManager.getData()
    }
}
