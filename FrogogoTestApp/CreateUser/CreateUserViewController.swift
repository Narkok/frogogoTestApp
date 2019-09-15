//
//  CreateUserViewController.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 15/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateUserViewController: UIViewController {

    let viewModel = CreateUserViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var firstNameInputView: InputView!
    @IBOutlet weak var lastNameInputView: InputView!
    @IBOutlet weak var emailInputView: InputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новый пользователь"
        
        // Кнопка 'создать' в навбаре
        let createButton = UIBarButtonItem(title: "Создать", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = createButton
        
        let firstNameIsValid = firstNameInputView.setup(withTitle: "Имя", inputType: .name)
        let lastNameIsValid = lastNameInputView.setup(withTitle: "Фамилия", inputType: .name)
        let emailIsValid = emailInputView.setup(withTitle: "Email", inputType: .email)
        
        
        
    
    }
}
