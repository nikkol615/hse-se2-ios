//
//  WishMakerViewController.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 9/23/25.
//

import UIKit

final class WishMakerViewController: UIViewController {
    private enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = -40
        static let stackLeading: CGFloat = 20
        static let titleFont: CGFloat = 32
        static let titleColor: UIColor = .black
        static let titleLeading: CGFloat = 20
        static let titleTop: CGFloat = 30
        static let toggleButtonTrailing: CGFloat = -20
        static let animationDuration: CGFloat = 0.3
        static let buttonHeight: CGFloat = 50
        static let buttonBottom: CGFloat = -20
        static let buttonSide: CGFloat = 20
        static let buttonRadius: CGFloat = 12
        static let buttonText: String = "My Wishes"
        static let scheduleButtonText: String = "Schedule Wishes"
        static let actionStackSpacing: CGFloat = 10
    }

    private let viewModel: WishMakerViewModel

    private var slidersStackView: UIStackView!
    private var toggleButton: ToggleButton!
    private var toggleButtonBottomConstraint: NSLayoutConstraint!
    private var sliderRed: ColorSliderView!
    private var sliderGreen: ColorSliderView!
    private var sliderBlue: ColorSliderView!

    private let actionStack: UIStackView = UIStackView()
    private let addWishButton: UIButton = UIButton(type: .system)
    private let scheduleWishesButton: UIButton = UIButton(type: .system)

    init(viewModel: WishMakerViewModel = WishMakerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = WishMakerViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        setupInitialState()
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .black

        configureTitle()
        configureActionStack()
        configureSliders()
        configureToggleButton()
    }

    private func bindViewModel() {
        viewModel.onColorChanged = { [weak self] colorModel in
            self?.updateBackgroundWithColor(colorModel.uiColor)
        }

        viewModel.onSlidersVisibilityChanged = { [weak self] isVisible in
            _ = self
        }
    }

    private func setupInitialState() {
        let initialColor = viewModel.getCurrentUIColor()
        view.backgroundColor = initialColor
        updateButtonColors(for: initialColor)

        let (red, green, blue) = viewModel.getCurrentRGBValues()
        sliderRed.setValue(red)
        sliderGreen.setValue(green)
        sliderBlue.setValue(blue)
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

    // MARK: - Action Stack (Points 1 & 2)
    private func configureActionStack() {
        actionStack.axis = .vertical
        actionStack.spacing = Constants.actionStackSpacing
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionStack)

        configureAddWishButton()
        configureScheduleButton()

        for button in [addWishButton, scheduleWishesButton] {
            actionStack.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            actionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonSide),
            actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonSide),
            actionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottom)
        ])
    }

    private func configureAddWishButton() {
        addWishButton.translatesAutoresizingMaskIntoConstraints = false
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.buttonText, for: .normal)
        addWishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)

        addWishButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
    }

    private func configureScheduleButton() {
        scheduleWishesButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleWishesButton.backgroundColor = .white
        scheduleWishesButton.setTitleColor(.systemPink, for: .normal)
        scheduleWishesButton.setTitle(Constants.scheduleButtonText, for: .normal)
        scheduleWishesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scheduleWishesButton.layer.cornerRadius = Constants.buttonRadius
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishButtonPressed), for: .touchUpInside)

        scheduleWishesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
    }

    private func configureSliders() {
        slidersStackView = UIStackView()
        slidersStackView.translatesAutoresizingMaskIntoConstraints = false
        slidersStackView.axis = .vertical
        view.addSubview(slidersStackView)
        slidersStackView.layer.cornerRadius = Constants.stackRadius
        slidersStackView.clipsToBounds = true

        sliderRed = ColorSliderView(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        sliderGreen = ColorSliderView(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        sliderBlue = ColorSliderView(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)

        sliderRed.valueChanged = { [weak self] value in
            self?.viewModel.updateRed(Float(value))
        }

        sliderGreen.valueChanged = { [weak self] value in
            self?.viewModel.updateGreen(Float(value))
        }

        sliderBlue.valueChanged = { [weak self] value in
            self?.viewModel.updateBlue(Float(value))
        }

        for slider in [sliderRed, sliderGreen, sliderBlue] {
            slidersStackView.addArrangedSubview(slider!)
        }

        NSLayoutConstraint.activate([
            slidersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slidersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            slidersStackView.bottomAnchor.constraint(equalTo: actionStack.topAnchor, constant: -20)
        ])
    }

    private func configureToggleButton() {
        toggleButton = ToggleButton(opened: true)
        view.addSubview(toggleButton)

        toggleButton.toggleAction = { [weak self] in
            self?.viewModel.toggleSlidersVisibility()
            self?.toggleStackVisibility()
        }

        toggleButtonBottomConstraint = toggleButton.bottomAnchor.constraint(
            equalTo: slidersStackView.topAnchor,
            constant: -10
        )

        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.toggleButtonTrailing
            ),
            toggleButtonBottomConstraint
        ])
    }

    // MARK: - Color Updates (Point 2 & 10)
    private func updateBackgroundWithColor(_ color: UIColor) {
        view.backgroundColor = color
        updateButtonColors(for: color)
    }

    private func updateButtonColors(for backgroundColor: UIColor) {
        let contrastColor = contrastingColor(for: backgroundColor)
        let buttonBackgroundColor = contrastColor.withAlphaComponent(0.9)

        for button in [addWishButton, scheduleWishesButton] {
            button.backgroundColor = buttonBackgroundColor
            button.setTitleColor(backgroundColor, for: .normal)
        }
    }

    private func contrastingColor(for color: UIColor) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance > 0.5 ? .black : .white
    }

    private func toggleStackVisibility() {
        let isHiding = !slidersStackView.isHidden

        UIView.animate(withDuration: Constants.animationDuration) {
            self.slidersStackView.alpha = isHiding ? 0 : 1

            self.toggleButtonBottomConstraint.isActive = false

            if isHiding {
                self.toggleButtonBottomConstraint = self.toggleButton.bottomAnchor.constraint(
                    equalTo: self.actionStack.topAnchor,
                    constant: -20
                )
            } else {
                self.toggleButtonBottomConstraint = self.toggleButton.bottomAnchor.constraint(
                    equalTo: self.slidersStackView.topAnchor,
                    constant: -10
                )
            }

            self.toggleButtonBottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.slidersStackView.isHidden = isHiding
        }
    }

    // MARK: - Actions
    @objc
    private func addWishButtonPressed() {
        let currentColor = viewModel.getCurrentUIColor()
        let vc = WishStoringViewController(backgroundColor: currentColor)
        present(vc, animated: true)
    }

    // MARK: - Point 3: Push WishCalendarViewController
    @objc
    private func scheduleWishButtonPressed() {
        let currentColor = viewModel.getCurrentUIColor()
        let vc = WishCalendarViewController(backgroundColor: currentColor)
        navigationController?.pushViewController(vc, animated: true)
    }
}
