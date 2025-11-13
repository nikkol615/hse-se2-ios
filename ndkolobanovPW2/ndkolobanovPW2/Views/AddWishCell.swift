//
//  AddWishCell.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 11/11/25.
//

import UIKit

final class AddWishCell: UITableViewCell {
    static let reuseId: String = "AddWishCell"
    
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let textViewHeight: CGFloat = 80
        static let textViewPadding: CGFloat = 12
        static let buttonHeight: CGFloat = 40
        static let buttonTopOffset: CGFloat = 8
        static let buttonSideOffset: CGFloat = 12
        static let placeholderText: String = "Enter your wish..."
        static let addButtonTitle: String = "Add Wish"
    }
    
    var addWish: ((String) -> Void)?
    
    private let wishTextView: UITextView = UITextView()
    private let addButton: UIButton = UIButton(type: .system)
    private let wrapView: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(wrapView)
        wrapView.translatesAutoresizingMaskIntoConstraints = false
        wrapView.backgroundColor = Constants.wrapColor
        wrapView.layer.cornerRadius = Constants.wrapRadius
        
        wrapView.addSubview(wishTextView)
        wishTextView.translatesAutoresizingMaskIntoConstraints = false
        wishTextView.font = UIFont.systemFont(ofSize: 16)
        wishTextView.layer.cornerRadius = 8
        wishTextView.layer.borderWidth = 1
        wishTextView.layer.borderColor = UIColor.systemGray4.cgColor
        wishTextView.textContainerInset = UIEdgeInsets(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8
        )
        wishTextView.text = Constants.placeholderText
        wishTextView.textColor = .lightGray
        wishTextView.delegate = self
        
        wrapView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle(Constants.addButtonTitle, for: .normal)
        addButton.backgroundColor = .systemPink
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            wrapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.wrapOffsetV),
            wrapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.wrapOffsetH),
            wrapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.wrapOffsetH),
            wrapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.wrapOffsetV),
            
            wishTextView.topAnchor.constraint(equalTo: wrapView.topAnchor, constant: Constants.textViewPadding),
            wishTextView.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.textViewPadding),
            wishTextView.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: -Constants.textViewPadding),
            wishTextView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),
            
            addButton.topAnchor.constraint(equalTo: wishTextView.bottomAnchor, constant: Constants.buttonTopOffset),
            addButton.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.buttonSideOffset),
            addButton.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: -Constants.buttonSideOffset),
            addButton.bottomAnchor.constraint(equalTo: wrapView.bottomAnchor, constant: -Constants.textViewPadding),
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    @objc
    private func addButtonTapped() {
        guard let text = wishTextView.text,
              !text.isEmpty,
              text != Constants.placeholderText else {
            return
        }
        
        addWish?(text)
        wishTextView.text = Constants.placeholderText
        wishTextView.textColor = .lightGray
        wishTextView.resignFirstResponder()
    }
}

extension AddWishCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholderText
            textView.textColor = .lightGray
        }
    }
}

