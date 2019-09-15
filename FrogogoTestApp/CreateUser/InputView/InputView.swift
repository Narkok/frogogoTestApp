//
//  InputView.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 15/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputView: NibView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var bottomLineHeightConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    
}

