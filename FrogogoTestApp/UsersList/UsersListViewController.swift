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
        
        viewModel.users.drive(tableView.rx.items) { tableView, row, item in
            let cell = tableView.cell(forType: UserCell.self)
            cell.nameLabel.text = "\(item.firstName) \(item.lastName)"
            cell.emailLabel.text = item.email
            return cell
        }.disposed(by: dispodeBag)
        
        viewModel.error.drive(onNext: { error in
            print(error)
        }).disposed(by: dispodeBag)
        
        tableView.rx.modelSelected(RequestData.User.self).subscribe(onNext: { user in
            print(user)
        }).disposed(by: dispodeBag)
        
    }
}



public extension UITableView {
    
    func cell<T: UITableViewCell>(forClass cellClass: T.Type, reuseIdentifierTag: String? = nil) -> T {
        let className = String(describing: cellClass)
        let reuseIdentifier = className + (reuseIdentifierTag ?? "")
        var isRegistered = false
        while true {
            if let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
                cell.selectionStyle = .none
                return cell
            }
            guard !isRegistered else { return T() }
            let bundle = Bundle(for: cellClass)
            if bundle.path(forResource: className, ofType: "nib") != nil {
                register(UINib(nibName: className, bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
            } else {
                register(cellClass, forCellReuseIdentifier: reuseIdentifier)
            }
            isRegistered = true
        }
    }
    
    func cell<T: UITableViewCell>(forType cellType: T.Type, reuseIdentifierTag: String? = nil) -> T {
        return cell(forClass: cellType, reuseIdentifierTag: reuseIdentifierTag)
    }
}
