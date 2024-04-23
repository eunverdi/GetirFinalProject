//
//  HeaderView.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 24.04.2024.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = Identifier.sectionHeaderIdentifier.rawValue

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        backgroundColor = UIColor.named(Constants.Colors.sectionHeaderColor)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        label.text = text
    }
}
