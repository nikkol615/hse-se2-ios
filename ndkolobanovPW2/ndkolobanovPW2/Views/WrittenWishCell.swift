//
//  WrittenWishCell.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 11/11/25.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    static let reuseId: String = "WrittenWishCell"
    
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
    }
    
    private let wishLabel: UILabel = UILabel()
    private let wrapView: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(wrapView)
        wrapView.translatesAutoresizingMaskIntoConstraints = false
        wrapView.backgroundColor = Constants.wrapColor
        wrapView.layer.cornerRadius = Constants.wrapRadius
        
        wrapView.addSubview(wishLabel)
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wishLabel.numberOfLines = 0
        wishLabel.textColor = .black
        
        NSLayoutConstraint.activate([
            wrapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.wrapOffsetV),
            wrapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.wrapOffsetH),
            wrapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.wrapOffsetH),
            wrapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.wrapOffsetV),
            
            wishLabel.topAnchor.constraint(equalTo: wrapView.topAnchor, constant: Constants.wishLabelOffset),
            wishLabel.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: Constants.wishLabelOffset),
            wishLabel.trailingAnchor.constraint(equalTo: wrapView.trailingAnchor, constant: -Constants.wishLabelOffset),
            wishLabel.bottomAnchor.constraint(equalTo: wrapView.bottomAnchor, constant: -Constants.wishLabelOffset)
        ])
    }
}

