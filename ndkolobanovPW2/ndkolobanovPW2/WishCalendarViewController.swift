//
//  WishCalendarViewController.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 02/10/26.
//

import UIKit

// MARK: - WishCalendarViewController
final class WishCalendarViewController: UIViewController {
    private enum Constants {
        static let contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        static let collectionTop: CGFloat = 10
        static let cellHeight: CGFloat = 130
        static let cellHorizontalInset: CGFloat = 10
        static let plusButtonSize: CGFloat = 56
        static let plusButtonBottom: CGFloat = -30
        static let plusButtonTrailing: CGFloat = -20
        static let plusButtonCornerRadius: CGFloat = 28
        static let plusButtonShadowRadius: CGFloat = 6
        static let plusButtonShadowOpacity: Float = 0.3
        static let plusButtonShadowOffset: CGSize = CGSize(width: 0, height: 3)
        static let emptyLabelFontSize: CGFloat = 18
        static let title: String = "Schedule"
    }

    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    private let addButton: UIButton = UIButton(type: .system)
    private let emptyLabel: UILabel = UILabel()
    private let eventStore: WishEventStore = WishEventStore()
    private let calendarManager: CalendarManager = CalendarManager()
    private var events: [WishEventModel] = []
    private var backgroundColor_: UIColor = .white

    // MARK: - Init
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor_ = backgroundColor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        view.backgroundColor = backgroundColor_
        loadEvents()
        configureCollection()
        configureAddButton()
        configureEmptyLabel()
        updateEmptyState()
    }

    // MARK: - Data
    private func loadEvents() {
        events = eventStore.events
    }

    private func updateEmptyState() {
        emptyLabel.isHidden = !events.isEmpty
        collectionView.isHidden = events.isEmpty
    }

    // MARK: - UI Configuration
    private func configureCollection() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
        }

        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.collectionTop),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = Constants.plusButtonCornerRadius
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowRadius = Constants.plusButtonShadowRadius
        addButton.layer.shadowOpacity = Constants.plusButtonShadowOpacity
        addButton.layer.shadowOffset = Constants.plusButtonShadowOffset
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: Constants.plusButtonSize),
            addButton.heightAnchor.constraint(equalToConstant: Constants.plusButtonSize),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.plusButtonTrailing),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.plusButtonBottom)
        ])
    }

    private func configureEmptyLabel() {
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No events yet.\nTap + to add one!"
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: Constants.emptyLabelFontSize)
        emptyLabel.textColor = .white

        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    // MARK: - Actions
    @objc
    private func addButtonPressed() {
        let savedWishes = (UserDefaults.standard.array(forKey: "savedWishes") as? [String]) ?? []
        let creationVC = WishEventCreationViewController(wishes: savedWishes)
        creationVC.onEventCreated = { [weak self] event in
            guard let self else { return }
            self.eventStore.addEvent(event)
            self.calendarManager.create(eventModel: event, completion: nil)
            self.events = self.eventStore.events
            self.collectionView.reloadData()
            self.updateEmptyState()
        }
        present(creationVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return events.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WishEventCell.reuseIdentifier,
            for: indexPath
        )

        guard let wishEventCell = cell as? WishEventCell else {
            return cell
        }

        wishEventCell.configure(with: events[indexPath.item])
        return wishEventCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width - Constants.cellHorizontalInset,
            height: Constants.cellHeight
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("Cell tapped at index \(indexPath.item)")
    }
}
