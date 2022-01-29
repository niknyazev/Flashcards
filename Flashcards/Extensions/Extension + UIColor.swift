//
//  Extension + UIColor.swift
//  Flashcards
//
//  Created by Николай on 29.01.2022.
//

import UIKit

extension UIColor {

    public convenience init(hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    var hexValue: Int {
        
        guard let components = self.cgColor.components,
              components.count >= 3 else { return 0 }
        
        let result = Int(components[0] * 255.0) << 16
            + Int(components[1] * 255.0) << 8
            + Int(components[2] * 255.0)
        
        return result
    }
}
