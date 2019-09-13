//
//  UserCell.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 14/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!


    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = highlighted ? .red : .white
    }
    
}
