//
//  UserCell.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 14/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit
import Kingfisher

class UserCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        /// Установка цвета фона выделенной ячейки
        backgroundColor = .init(white: highlighted ? 0.9 : 1, alpha: 1)
    }
    
    /// Настройка ячейки для отображения пользователя
    func setup(for user: UserInfo) {
        
        /// Установка надписей
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        emailLabel.text = user.email
        
        /// Загрузка аватарки, если есть
        if let avatarUrl = user.avatarUrl, let url = URL(string: avatarUrl) {
            avatarImageView.kf.setImage(with: url)
        }
        else {
            avatarImageView.image = UIImage(named: "emptyAvatar")
            avatarImageView.backgroundColor = .color(by: user.id)
        }
    }
}
