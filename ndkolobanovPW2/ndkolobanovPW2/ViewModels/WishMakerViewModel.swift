//
//  WishMakerViewModel.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 9/23/25.
//

import UIKit

final class WishMakerViewModel {
    private(set) var currentColor: ColorModel {
        didSet {
            onColorChanged?(currentColor)
        }
    }
    
    private(set) var isSlidersVisible: Bool {
        didSet {
            onSlidersVisibilityChanged?(isSlidersVisible)
        }
    }
    
    var onColorChanged: ((ColorModel) -> Void)?
    
    var onSlidersVisibilityChanged: ((Bool) -> Void)?
    
    init(initialColor: ColorModel = .black, slidersVisible: Bool = true) {
        self.currentColor = initialColor
        self.isSlidersVisible = slidersVisible
    }
    
    func updateRed(_ value: Float) {
        currentColor.red = value
    }
    
    func updateGreen(_ value: Float) {
        currentColor.green = value
    }
    
    func updateBlue(_ value: Float) {
        currentColor.blue = value
    }
    
    func toggleSlidersVisibility() {
        isSlidersVisible.toggle()
    }
    
    func setRandomColor() {
        currentColor = ColorModel(
            red: Float.random(in: 0...1),
            green: Float.random(in: 0...1),
            blue: Float.random(in: 0...1)
        )
    }
    
    func setPresetColor(_ color: ColorModel) {
        currentColor = color
    }
    
    func getCurrentUIColor() -> UIColor {
        return currentColor.uiColor
    }
    
    func getCurrentRGBValues() -> (red: Float, green: Float, blue: Float) {
        return (currentColor.red, currentColor.green, currentColor.blue)
    }
}

