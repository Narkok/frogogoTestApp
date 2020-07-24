//
//  UIColor+ColorBy.swift
//  UsersAPIfrontendApp
//
//  Created by Narek Stepanyan on 15/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit

public extension UIColor {
    /// Получить цвет по id
    static func color(by strId: String) -> UIColor {
        let colors = [#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                      #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
                      #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                      #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 1, green: 0, blue: 0.1411905885, alpha: 1),#colorLiteral(red: 0.9779763818, green: 0.410820365, blue: 0.06041189283, alpha: 1)]
        let id = strId
            .filter{ $0.isNumber }
            .reversed()
            .prefix(10)
            .map { String($0) }
            .reduce("", +)
        return colors[(Int(id) ?? 0) % colors.count]
    }
}
