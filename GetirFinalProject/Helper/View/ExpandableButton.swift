//
//  ExpandableButton.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 16.04.2024.
//

//    var addToCartButton: ExpandableButton = {
//        let button1 = UIButton(type: .system)
//        button1.backgroundColor = Constants.Colors.appMainColor
//        let label = UILabel()
//        label.textColor = .white
//        label.text = "1"
//        label.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 1
//        button1.addSubview(label)
//
//        label.centerXAnchor.constraint(equalTo: button1.centerXAnchor).isActive = true
//        label.centerYAnchor.constraint(equalTo: button1.centerYAnchor).isActive = true
//
//        let button2 = UIButton(type: .system)
//        button2.backgroundColor = .white
//        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .default)
//        let image = UIImage(systemName: "trash.fill", withConfiguration: config)?.withTintColor(Constants.Colors.appMainColor!, renderingMode: .alwaysOriginal)
//        button2.setImage(image, for: .normal)
//        button2.tintColor = Constants.Colors.appMainColor
//        button2.layer.cornerRadius = 6
//        button2.layer.shadowColor = UIColor.black.cgColor
//        button2.layer.shadowOffset = CGSize(width: 0, height: 1)
//        button2.layer.shadowOpacity = 0.1
//        button2.layer.shadowRadius = 2.0
//
//        let button = ExpandableButton(buttons: [button1, button2])
//        button.setImage(UIImage(named: "addToCartButtonImage"), for: .normal)
//        button.backgroundColor = .white
//        button.tintColor = Constants.Colors.appMainColor
//        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
//        button.layer.cornerRadius = 6
//        button.layer.zPosition = 1
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 1)
//        button.layer.shadowOpacity = 0.1
//        button.layer.shadowRadius = 2.0
//        return button
//    }()

import UIKit

final class ExpandableButton: UIButton {
    var isExpanded = false
    private let buttons: [UIButton]

    init(buttons: [UIButton]) {
        self.buttons = buttons
        super.init(frame: .zero)

        addTarget(self, action: #selector(toggle), for: .touchUpInside)

        for button in buttons {
            button.isHidden = true
            addSubview(button)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func toggle() {
        isExpanded.toggle()
        UIView.animate(withDuration: 0.4) {
            for (index, button) in self.buttons.enumerated() {
                let yOffset = self.isExpanded ? CGFloat(index + 1) * self.frame.height : 0
                button.frame = CGRect(x: 0, y: yOffset, width: self.frame.width, height: self.frame.height)
                button.isHidden = !self.isExpanded
            }
            self.layoutIfNeeded()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !isExpanded {
            for button in buttons {
                button.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
            }
        }
    }
}
