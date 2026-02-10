//
//  WishEventCreationViewController.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 02/10/26.
//

import UIKit

// MARK: - WishEventCreationViewController
final class WishEventCreationViewController: UIViewController {
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 30
        static let fieldSpacing: CGFloat = 12
        static let textFieldHeight: CGFloat = 44
        static let datePickerHeight: CGFloat = 44
        static let buttonHeight: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 12
        static let titleFontSize: CGFloat = 22
        static let labelFontSize: CGFloat = 14
        static let containerTopPadding: CGFloat = 20
        static let scrollBottomPadding: CGFloat = 40
        static let wishPickerHeight: CGFloat = 44
    }

    var onEventCreated: ((WishEventModel) -> Void)?

    private let wishes: [String]
    private var selectedWish: String?

    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let titleField: UITextField = UITextField()
    private let descriptionField: UITextField = UITextField()
    private let startDatePicker: UIDatePicker = UIDatePicker()
    private let endDatePicker: UIDatePicker = UIDatePicker()
    private let saveButton: UIButton = UIButton(type: .system)
    private let wishPickerButton: UIButton = UIButton(type: .system)

    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    private let wishLabel: UILabel = UILabel()

    // MARK: - Init
    init(wishes: [String] = []) {
        self.wishes = wishes
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }

    // MARK: - UI Configuration
    private func configureUI() {
        configureScrollView()
        configureTitleLabel()
        configureTitleField()
        configureDescriptionField()
        configureWishPicker()
        configureStartDateSection()
        configureEndDateSection()
        configureSaveButton()
    }

    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "New Event"
        titleLabel.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding)
        ])
    }

    private func configureTitleField() {
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.placeholder = "Event title"
        titleField.borderStyle = .roundedRect
        titleField.font = .systemFont(ofSize: 16)
        contentView.addSubview(titleField)

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.containerTopPadding),
            titleField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            titleField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            titleField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }

    private func configureDescriptionField() {
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.placeholder = "Event description"
        descriptionField.borderStyle = .roundedRect
        descriptionField.font = .systemFont(ofSize: 16)
        contentView.addSubview(descriptionField)

        NSLayoutConstraint.activate([
            descriptionField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: Constants.fieldSpacing),
            descriptionField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            descriptionField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            descriptionField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }

    private func configureWishPicker() {
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wishLabel.text = "Pick a wish (optional):"
        wishLabel.font = .systemFont(ofSize: Constants.labelFontSize)
        wishLabel.textColor = .secondaryLabel
        contentView.addSubview(wishLabel)

        wishPickerButton.translatesAutoresizingMaskIntoConstraints = false
        wishPickerButton.setTitle("Select a wish...", for: .normal)
        wishPickerButton.contentHorizontalAlignment = .left
        wishPickerButton.titleLabel?.font = .systemFont(ofSize: 16)
        wishPickerButton.setTitleColor(.label, for: .normal)
        wishPickerButton.layer.borderWidth = 1
        wishPickerButton.layer.borderColor = UIColor.systemGray4.cgColor
        wishPickerButton.layer.cornerRadius = 8
        wishPickerButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        wishPickerButton.addTarget(self, action: #selector(wishPickerTapped), for: .touchUpInside)
        contentView.addSubview(wishPickerButton)

        NSLayoutConstraint.activate([
            wishLabel.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: Constants.fieldSpacing),
            wishLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            wishLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),

            wishPickerButton.topAnchor.constraint(equalTo: wishLabel.bottomAnchor, constant: 6),
            wishPickerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            wishPickerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            wishPickerButton.heightAnchor.constraint(equalToConstant: Constants.wishPickerHeight)
        ])

        wishPickerButton.isHidden = wishes.isEmpty
        wishLabel.isHidden = wishes.isEmpty
    }

    private func configureStartDateSection() {
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.text = "Start date:"
        startDateLabel.font = .systemFont(ofSize: Constants.labelFontSize)
        startDateLabel.textColor = .secondaryLabel
        contentView.addSubview(startDateLabel)

        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .compact
        }
        startDatePicker.minimumDate = Date()
        contentView.addSubview(startDatePicker)

        let topAnchor = wishes.isEmpty ? descriptionField.bottomAnchor : wishPickerButton.bottomAnchor

        NSLayoutConstraint.activate([
            startDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.fieldSpacing),
            startDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            startDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),

            startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 6),
            startDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            startDatePicker.heightAnchor.constraint(equalToConstant: Constants.datePickerHeight)
        ])
    }

    private func configureEndDateSection() {
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.text = "End date:"
        endDateLabel.font = .systemFont(ofSize: Constants.labelFontSize)
        endDateLabel.textColor = .secondaryLabel
        contentView.addSubview(endDateLabel)

        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            endDatePicker.preferredDatePickerStyle = .compact
        }
        endDatePicker.minimumDate = Date()
        contentView.addSubview(endDatePicker)

        NSLayoutConstraint.activate([
            endDateLabel.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: Constants.fieldSpacing),
            endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            endDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),

            endDatePicker.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 6),
            endDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            endDatePicker.heightAnchor.constraint(equalToConstant: Constants.datePickerHeight)
        ])
    }

    private func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Create Event", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveButton.layer.cornerRadius = Constants.buttonCornerRadius
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        contentView.addSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: Constants.containerTopPadding),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.scrollBottomPadding)
        ])
    }

    // MARK: - Actions
    @objc
    private func wishPickerTapped() {
        let alert = UIAlertController(
            title: "Pick a Wish",
            message: "Select a wish to use as event title",
            preferredStyle: .actionSheet
        )

        for wish in wishes {
            let action = UIAlertAction(title: wish, style: .default) { [weak self] _ in
                self?.selectedWish = wish
                self?.titleField.text = wish
                self?.wishPickerButton.setTitle(wish, for: .normal)
            }
            alert.addAction(action)
        }

        let clearAction = UIAlertAction(title: "Clear Selection", style: .destructive) { [weak self] _ in
            self?.selectedWish = nil
            self?.wishPickerButton.setTitle("Select a wish...", for: .normal)
        }
        alert.addAction(clearAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    @objc
    private func saveButtonPressed() {
        guard let title = titleField.text, !title.isEmpty else {
            showAlert(message: "Please enter an event title.")
            return
        }

        let startDate = startDatePicker.date
        let endDate = endDatePicker.date

        guard endDate > startDate else {
            showAlert(message: "End date must be after start date.")
            return
        }

        let event = WishEventModel(
            title: title,
            description: descriptionField.text ?? "",
            startDate: startDate,
            endDate: endDate
        )

        onEventCreated?(event)
        dismiss(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
