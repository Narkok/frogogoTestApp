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
    
    private let bottomLineSelectedHeight: CGFloat = 3
    private let bottomLineDeselectedHeight: CGFloat = 2
    
    private let bottomLineErrorColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    private let bottomLineNormalColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    private let bottomLineSelectedColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    
    let disposeBag = DisposeBag()
    
    
    /// Настройка поля ввода текста
    /// Возвращает Observable из строки и её валидности
    func setup(withTitle title: String, text: String = "", inputType: Type) -> Observable<(isValid: Bool, string: String)> {
        
        titleLabel.text = title
        textField.text = text
        
        // Анимация выбора поля ввода
        textField.rx.controlEvent(.editingDidBegin).subscribe(onNext:{ [weak self] in
            guard let self = self else { return }
            self.bottomLineHeightConstraint.constant = self.bottomLineSelectedHeight
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
                self?.bottomLine.backgroundColor = self?.bottomLineSelectedColor
            })
        }).disposed(by: disposeBag)
        
        
        // Введенная в поле строка
        let inputText = textField.rx.controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text)
            .map { $0 ?? "" }
        
        
        // Валидность введенной строки
        let isInputValid = inputText
            .map { InputView.check($0, for: inputType) }


        // Конец ввода строки в поле
        let onEditingDidEnd = textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(isInputValid)


        // Анимация отмены выделения поля
        // Покрасить линию в цвет в зависимости от валидности введенных данных
        onEditingDidEnd.subscribe(onNext: { [weak self] isValid in
            guard let self = self else { return }
            self.bottomLineHeightConstraint.constant = self.bottomLineDeselectedHeight
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded()
                // Цвет линии в зависимости от валидности строки
                self.bottomLine.backgroundColor = isValid ? self.bottomLineNormalColor : self.bottomLineErrorColor
            })
        }).disposed(by: disposeBag)
        
        return Observable.combineLatest(isInputValid, inputText).map { (isValid: $0, string: $1) }
    }
    
    
    /// enum для типов полей ввода
    enum `Type` {
        case email
        case name
        case avatarURL
    }
    
    
    /// Проверка валидности введенной строки
    static func check(_ string: String, for type: Type) -> Bool {
        switch type {
        // Правильный формат почты
        case .email:
            let emailRegEx = "([A-Z0-9a-z._%+-])+@([A-Za-z0-9.-])+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: string)
         
        // Непустая строка для имени
        case .name:
            return string != ""
            
        // Любой тест для ссылки на аватарку
        case .avatarURL:
            return true
        }
    }
}

