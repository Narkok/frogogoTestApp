//
//  UsersListViewController.swift
//  UsersAPIfrontendApp
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
    @IBOutlet weak var emptyListLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пользователи"
        tableView.alpha = 0
        
        /// Кнопка 'Обновить' в навбаре
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = refreshButton
        
        
        /// Кнопка 'Добавить' в навбаре
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton
        
        
        /// Запрос на обновление списка
        refreshButton.rx.tap
            .bind(to: viewModel.reloadData)
            .disposed(by: disposeBag)
        
        
        /// Переход на экран создания пользователя
        addButton.rx.tap.subscribe(onNext:{ [weak self] in
            let createUserViewControler = UserDetailsViewController()
            self?.navigationController?.pushViewController(createUserViewControler, animated: true)
        }).disposed(by: disposeBag)
        
        
        /// Показать надпись при пустом списке
        viewModel.emptyList
            .map { !$0 }
            .drive(emptyListLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        /// Спятать таблицу при пустом списке
        viewModel.emptyList
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        /// Показать надпись во время загрузки
        viewModel.isLoading.filter { $0 }
            .drive(emptyListLabel.rx.isHidden)
            .disposed(by: disposeBag)

        
        /// Загрузка данных в tableView
        viewModel.users.drive(tableView.rx.items) { tableView, row, user in
            let cell = tableView.getCell(forClass: UserCell.self)
            cell.setup(for: user)
            return cell
        }.disposed(by: disposeBag)
    
        
        /// Анимация loadingIndicator
        viewModel.isLoading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        /// Показать tableView
        viewModel.isLoading.drive(onNext: { isLoading in
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.tableView.alpha = isLoading ? 0 : 1
            })
        }).disposed(by: disposeBag)
        
        
        /// Oшибки
        viewModel.error
            .drive(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        
        /// Переход на экран редактирования пользователя
        tableView.rx.modelSelected(UserInfo.self)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                let createUserViewControler = UserDetailsViewController()
                createUserViewControler.user = user
                /// Обновить список после изменения/добавления пользователя
                createUserViewControler
                    .reloadData.bind(to: self.viewModel.reloadData)
                    .disposed(by: createUserViewControler.disposeBag)
                self.navigationController?.pushViewController(createUserViewControler, animated: true)
            }).disposed(by: disposeBag)
    }
}
