//
//  UsersListViewController.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit
import RxSwift

class UsersListViewController: UIViewController {
    
    let viewModel = UsersListViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пользователи"
        tableView.alpha = 0
        
        
        // Кнопка 'добавить' в навбаре
        let addButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton
        
        
        // Переход на экран создания пользователя
        addButton.rx.tap.subscribe(onNext:{ [weak self] in
            let createUserViewControler = UserDetailsViewController()
            self?.navigationController?.pushViewController(createUserViewControler, animated: true)
        }).disposed(by: disposeBag)
        
        
        // Загрузка данных в tableView
        viewModel.users.drive(tableView.rx.items) { tableView, row, user in
            let cell = tableView.getCell(forClass: UserCell.self)
            cell.setup(for: user)
            return cell
        }.disposed(by: disposeBag)
    
        
        // Анимация loadingIndicator
        viewModel.isLoading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        // Показать tableView
        viewModel.loadIsFinished.drive(onNext: {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.tableView.alpha = 1
            })
        }).disposed(by: disposeBag)
        
        
        // Вывод ошибки
        viewModel.error.drive(onNext: { error in
            print(error)
        }).disposed(by: disposeBag)
        
        
        // Переход на экран редактирования пользователя
        tableView.rx.modelSelected(UserInfo.self)
            .subscribe(onNext: { [weak self] user in
                let createUserViewControler = UserDetailsViewController()
                createUserViewControler.user = user
                self?.navigationController?.pushViewController(createUserViewControler, animated: true)
            }).disposed(by: disposeBag)
        
    }
}
