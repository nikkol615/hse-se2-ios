//
//  ColorModel.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 9/23/25.
//

import UIKit

struct ColorModel {
    var red: Float
    var green: Float
    var blue: Float
    
    init(red: Float = 0, green: Float = 0, blue: Float = 0) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    var uiColor: UIColor {
        return UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: 1.0
        )
    }
    
    static let black = ColorModel(red: 0, green: 0, blue: 0)
    static let white = ColorModel(red: 1, green: 1, blue: 1)
    static let red = ColorModel(red: 1, green: 0, blue: 0)
    static let green = ColorModel(red: 0, green: 1, blue: 0)
    static let blue = ColorModel(red: 0, green: 0, blue: 1)
}

