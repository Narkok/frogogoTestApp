//
//  UsersListViewModel.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UsersListViewModel {
    
    let dataManager = UsersDataManager()
    
    let users: Driver<[RequestData.User]>
    let error: Driver<String>
    
    init() {
        let data = dataManager.result
            .map { $0.element ?? [] }
        
        let errorText = dataManager.result
            .map { $0.error }
            .filter { $0 != nil }
            .map { $0 as! UsersDataManager.UsersDataManagerError }
            .map { $0.text }
        
        error = errorText.asDriver(onErrorJustReturn: "")
        users = data.asDriver(onErrorJustReturn: [])
        
        dataManager.getData()
    }
}
