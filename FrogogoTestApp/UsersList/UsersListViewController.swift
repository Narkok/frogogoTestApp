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
    let dispodeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пользователи"
        tableView.alpha = 0
        
        // Загрузка данных в tableView
        viewModel.users.drive(tableView.rx.items) { tableView, row, item in
            let cell = tableView.getCell(forClass: UserCell.self)
            cell.nameLabel.text = "\(item.firstName) \(item.lastName)"
            cell.emailLabel.text = item.email
            return cell
        }.disposed(by: dispodeBag)
    
        // Анимация loadingIndicator
        viewModel.isLoading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: dispodeBag)
        
        // Показать tableView
        viewModel.loadIsFinished.drive(onNext: {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.tableView.alpha = 1
            })
        }).disposed(by: dispodeBag)
        
        // Вывод ошибки
        viewModel.error.drive(onNext: { error in
            print(error)
        }).disposed(by: dispodeBag)
        
        // Отправка выбранного пользователя в viewModel
        tableView.rx.modelSelected(UserInfo.self)
            .subscribe(onNext: { [weak self] user in
                print(user)
            }).disposed(by: dispodeBag)
        
    }
}
