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
        createButton.rx.tap.bind(to: viewModel.createButton).disposed(by: disposeBag)
        
        // Настройка полей ввода и отравка результатов в viewModel
        firstNameInputView.setup(withTitle: "Имя", inputType: .name)
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        lastNameInputView.setup(withTitle: "Фамилия", inputType: .name)
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        
        emailInputView.setup(withTitle: "Email", inputType: .email)
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        // Вернуться на предыдущий экран
        viewModel.requestResult.drive(onNext:{ [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
