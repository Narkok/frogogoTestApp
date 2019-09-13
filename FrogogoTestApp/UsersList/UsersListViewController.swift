//
//  UsersListViewController.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UsersListViewController: UIViewController {
    
    let viewModel = UsersListViewModel()
    let dispodeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.users
            .drive(tableView.rx.items) { tableView, _, item in
                let cell = UITableViewCell()
                cell.textLabel?.text = item.firstName
                return cell
        }.disposed(by: dispodeBag)
        
        viewModel.error.drive(onNext: { error in
            print(error)
        }).disposed(by: dispodeBag)
        
    }
}
