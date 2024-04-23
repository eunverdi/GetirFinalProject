//
//  CartButtonView.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 20.04.2024.
//

import UIKit

protocol CartButtonViewProtocol: AnyObject {
    func cartButtonPressed()
}

class CartButtonView: UIView {
    
    weak var delegate: CartButtonViewProtocol?
    private var buttonEnabled: Bool = true
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.named(Constants.ImageName.cartButtonIcon)
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "₺0,00"
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)
        label.textColor = UIColor.named(Constants.Colors.appMainColor)
        label.textAlignment = .center
        label.backgroundColor = UIColor.named(Constants.Colors.productImageBorderColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        return stackView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNotification()
        configureSuperview()
        configureSubviews()
        setConstraints()
        ProductRepository.shared.calculateTotalCost()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartButtonView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.35),
            label.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.65),
            
            widthAnchor.constraint(equalToConstant: 90),
            heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

extension CartButtonView {
    private func configureSuperview() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressed)))
    }
}

extension CartButtonView {
    private func configureSubviews() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
}

extension CartButtonView {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalCost(_:)), name: Constants.NotificationName.totalCost, object: nil)
    }
}

extension CartButtonView {
    @objc private func pressed() {
        if buttonEnabled {
            self.delegate?.cartButtonPressed()
        }
    }
}

extension CartButtonView {
    @objc func updateTotalCost(_ notification: Notification) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        if let totalCost = notification.userInfo?[Constants.NotificationUserInfo.totalCostUpdated] as? Double,
           let formattedString = formatter.string(from: NSNumber(value: totalCost)) {

            self.buttonEnabled = totalCost == 0.0 ? false : true
            
            DispatchQueue.main.async {
                self.label.text = "₺\(formattedString)"
                if formattedString.count > 8 {
                    self.label.font = UIFont(name: Constants.Fonts.openSansBold, size: 10)
                } else {
                    self.label.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)
                }
            }
        }
    }
}
