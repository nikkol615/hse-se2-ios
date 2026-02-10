//
//  WishEventCell.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 02/10/26.
//

import UIKit

// MARK: - WishEventCell
final class WishEventCell: UICollectionViewCell {
    static let reuseIdentifier: String = "WishEventCell"

    private enum Constants {
        static let offset: CGFloat = 5
        static let cornerRadius: CGFloat = 16
        static let backgroundColor: UIColor = .white
        static let titleTop: CGFloat = 12
        static let titleLeading: CGFloat = 16
        static let titleTrailing: CGFloat = -16
        static let descriptionTop: CGFloat = 4
        static let dateTop: CGFloat = 8
        static let dateBottom: CGFloat = -12
        static let titleFont: UIFont = .boldSystemFont(ofSize: 16)
        static let descriptionFont: UIFont = .systemFont(ofSize: 14)
        static let dateFont: UIFont = .systemFont(ofSize: 12)
        static let dateLabelColor: UIColor = .darkGray
    }

    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cell Configuration
    func configure(with event: WishEventModel) {
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = "Start: \(event.startDateString)"
        endDateLabel.text = "End: \(event.endDateString)"
    }

    // MARK: - UI Configuration
    private func configureWrap() {
        contentView.addSubview(wrapView)
        wrapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            wrapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.offset),
            wrapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset),
            wrapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset),
            wrapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.offset)
        ])

        wrapView.layer.cornerRadius = Constants.cornerRadius
        wrapView.backgroundColor = Constants.backgroundColor
        wrapView.clipsToBounds = true
    }

    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .black

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: wrapView.topAnchor, constant: Constants.titleTop),
            titleLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: Constants.titleTrailing)
        ])
    }

    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 2

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.descriptionTop),
            descriptionLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.titleLeading),
            descriptionLabel.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: Constants.titleTrailing)
        ])
    }

    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.font = Constants.dateFont
        startDateLabel.textColor = Constants.dateLabelColor

        NSLayoutConstraint.activate([
            startDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.dateTop),
            startDateLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.titleLeading),
            startDateLabel.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: Constants.titleTrailing)
        ])
    }

    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.font = Constants.dateFont
        endDateLabel.textColor = Constants.dateLabelColor

        NSLayoutConstraint.activate([
            endDateLabel.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: Constants.descriptionTop),
            endDateLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.titleLeading),
            endDateLabel.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: Constants.titleTrailing),
            endDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: wrapView.bottomAnchor, constant: Constants.dateBottom)
        ])
    }
}
