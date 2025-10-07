//
//  ViewController.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 9/23/25.
//

import UIKit


final class CustomSlider: UIView {
    var valueChanged: ((Double) -> Void)?
    enum Constants {
        static let titleTop: CGFloat = 10
        static let titleLeading: CGFloat = 20
        static let sliderBottom: CGFloat = -10
        static let sliderLeading: CGFloat = 20
    }
    
    var slider = UISlider()
    var titleView = UILabel()
    
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI ()
    }
    
    @available(*, unavailable)
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        for view in [slider, titleView] {
            addSubview (view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleTop),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLeading),
            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.sliderBottom),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.sliderLeading)
        ])
    }
    @objc
    private func sliderValueChanged() {
        valueChanged? (Double (slider.value))
    }
}

final class CustomButton: UIButton {
    var toggleAction: (() -> Void)?
    
    enum Constants {
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
    
    func setOpened(_ opened: Bool) {
        isOpened = opened
    }
}
                        

final class WishMakerViewController: UIViewController {
    enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        static let alpha: Double = 1.0
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = -40
        static let stackLeading: CGFloat = 20
        static let titleFont: CGFloat = 32
        static let titleColor: UIColor = .black
        static let titleLeading: CGFloat = 20
        static let titleTop: CGFloat = 30
        static let toggleButtonTrailing: CGFloat = -20
        static let animationDuration: CGFloat = 0.3
    }
    
    private var slidersStackView: UIStackView!
    private var toggleButton: CustomButton!
    private var toggleButtonBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func configureUI() {
        view.backgroundColor = .black
        
        configureTitle()
        configureSliders()
        configureToggleButton()
    }
    
    private func configureTitle() {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "WishMaker"
        title.font = UIFont.systemFont(ofSize: Constants.titleFont)
        title.textColor = Constants.titleColor
        
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleLeading),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTop)
        ])
    }
    private func configureSliders() {
        slidersStackView = UIStackView()
        slidersStackView.translatesAutoresizingMaskIntoConstraints = false
        slidersStackView.axis = .vertical
        view.addSubview(slidersStackView)
        slidersStackView.layer.cornerRadius = Constants.stackRadius
        slidersStackView.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        for slider in [sliderRed, sliderBlue, sliderGreen] {
            slidersStackView.addArrangedSubview(slider)
            slider.valueChanged = { [weak self] value in
            self?.view.backgroundColor = UIColor(
                red: CGFloat(sliderRed.slider.value),
                green: CGFloat(sliderGreen.slider.value),
                blue: CGFloat(sliderBlue.slider.value),
                alpha: CGFloat(Constants.alpha)
            )
        }
        }
        NSLayoutConstraint.activate([
            slidersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slidersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            slidersStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackBottom)
        ])
    }
    
    private func configureToggleButton() {
        toggleButton = CustomButton(opened: true)
        view.addSubview(toggleButton)
        
        toggleButton.toggleAction = { [weak self] in
            self?.toggleStackVisibility()
        }
        
        toggleButtonBottomConstraint = toggleButton.bottomAnchor.constraint(equalTo: slidersStackView.topAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.toggleButtonTrailing),
            toggleButtonBottomConstraint
        ])
    }
    
    private func toggleStackVisibility() {
        let isHiding = !slidersStackView.isHidden
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.slidersStackView.alpha = isHiding ? 0 : 1
            
            if isHiding {
                self.toggleButtonBottomConstraint.isActive = false
                self.toggleButtonBottomConstraint = self.toggleButton.bottomAnchor.constraint(
                    equalTo: self.view.bottomAnchor, 
                    constant: Constants.stackBottom
                )
                self.toggleButtonBottomConstraint.isActive = true
            } else {

                self.toggleButtonBottomConstraint.isActive = false
                self.toggleButtonBottomConstraint = self.toggleButton.bottomAnchor.constraint(
                    equalTo: self.slidersStackView.topAnchor, 
                    constant: -10
                )
                self.toggleButtonBottomConstraint.isActive = true
            }
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.slidersStackView.isHidden = isHiding
        }
    }
}
