//
//  UsersListViewModel.swift
//  UsersAPIfrontendApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import RxCocoa
import RxSwift

class UsersListViewModel {
    
    private static let dataManager = UsersDataManager()
    
    /// Выходы в контроллер
    let users: Driver<[UserInfo]>
    let error: Driver<String>
    let isLoading: Driver<Bool>
    let loadIsFinished: Driver<Void>
    let emptyList: Driver<Bool>
    
    /// Запрос на обновление
    let reloadData = PublishRelay<Void>()
    
    init() {
        /// Начало загрузки
        let startLoadData = reloadData
            .startWith(())
        
        /// Список пользователей
        let usersListResponse = startLoadData
            .flatMapLatest { UsersListViewModel.dataManager.getData() }
            .share(replay: 1)
        
        let usersList = usersListResponse
            .map { $0.element ?? [] }
            .map { $0.sorted() }
        
        /// Состояние загрузки
        let loadingTrue = startLoadData
            .map { _ in true }
        let loadingFalse = usersListResponse
            .map { _ in false }
        let isLoading = Observable.merge(loadingTrue, loadingFalse)
            .startWith(true)
        
        /// Загрузка данных завершена
        let loadIsFinished = usersListResponse
            .map { _ in () }
        
        /// Текст ошибки
        let errorText = usersListResponse
            .map { $0.error as? UsersDataManagerError }
            .filter { $0 != nil }
            .map { $0!.text }
        
        /// Список пользователей пустой
        let emptyList = usersList
            .map { $0.isEmpty }
        
        self.error = errorText.asDriver(onErrorJustReturn: "")
        self.users = usersList.asDriver(onErrorJustReturn: [])
        self.isLoading = isLoading.asDriver(onErrorJustReturn: false)
        self.loadIsFinished = loadIsFinished.asDriver(onErrorJustReturn: ())
        self.emptyList = emptyList.asDriver(onErrorJustReturn: false)
    }
}
