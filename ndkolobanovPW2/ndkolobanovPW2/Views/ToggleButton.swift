//
//  ToggleButton.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 9/23/25.
//

import UIKit

final class ToggleButton: UIButton {
    var toggleAction: (() -> Void)?
    
    private enum Constants {
        static let buttonHeight: CGFloat = 44
        static let buttonWidth: CGFloat = 44
        static let cornerRadius: CGFloat = 22
    }
    
    private var isOpened: Bool = true {
        didSet {
            updateArrowDirection()
        }
    }
    
    init(opened: Bool = true) {
        self.isOpened = opened
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOpened(_ opened: Bool) {
        isOpened = opened
    }
    
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Constants.cornerRadius
        
        updateArrowDirection()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            widthAnchor.constraint(equalToConstant: Constants.buttonWidth)
        ])
    }
    
    private func updateArrowDirection() {
        let imageName = isOpened ? "chevron.down" : "chevron.up"
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        setImage(image, for: .normal)
        tintColor = .black
    }
    
    @objc
    private func buttonTapped() {
        isOpened.toggle()
        toggleAction?()
    }
}

