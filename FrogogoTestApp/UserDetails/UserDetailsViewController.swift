//
//  UserDetailsViewController.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 15/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailsViewController: UIViewController {

    let viewModel = UserDetailsViewModel()
    let disposeBag = DisposeBag()
    var user: UserInfo?
    
    @IBOutlet weak var firstNameInputView: InputView!
    @IBOutlet weak var lastNameInputView: InputView!
    @IBOutlet weak var emailInputView: InputView!
    @IBOutlet weak var inputs: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user == nil ? "Новый пользователь" : "\(user!.firstName) \(user!.lastName)"
        
        // Кнопка 'создать' в навбаре
        let createButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = createButton
        createButton.rx.tap.bind(to: viewModel.createButton).disposed(by: disposeBag)
        
        // Настройка полей ввода и отравка результатов в viewModel
        firstNameInputView.setup(withTitle: "Имя", text: user?.firstName ?? "", inputType: .name)
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        lastNameInputView.setup(withTitle: "Фамилия", text: user?.lastName ?? "", inputType: .name)
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        
        emailInputView.setup(withTitle: "Email", text: user?.email ?? "", inputType: .email)
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        // Вернуться на предыдущий экран
        viewModel.requestResult?.drive(onNext:{ [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        // Активация кнопки 'Создать'
        viewModel.buttonIsActive?
            .drive(createButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Блокировка кнопки во время отправки запроса
        viewModel.blockScreen?.drive(onNext:{ [weak self, createButton] in
            createButton.isEnabled = false
            self?.view.endEditing(true)
            self?.descriptionLabel.isHidden = false
            self?.loadingIndicator.startAnimating()
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.inputs.alpha = 0.4
            })
        }).disposed(by: disposeBag)
    }
}
