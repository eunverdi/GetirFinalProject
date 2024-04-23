//
//  CartListContainerView.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 22.04.2024.
//

import UIKit

protocol CartListContainverViewProtocol: AnyObject {
    func makeOrderButtonPressed(totalCost: String)
}

final class CartListContainerView: UIView {
    
    weak var delegate: CartListContainverViewProtocol?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        view.color = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let makeOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.ButtonTitle.completeOrder, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.Fonts.openSansBold, size: 16)
        button.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        button.tintColor = .white
        button.addTarget(self, action: #selector(makeOrderButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.named(Constants.Colors.appMainColor)
        label.font = UIFont(name: Constants.Fonts.openSansBold, size: 20)
        return label
    }()
    
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.layer.cornerRadius = 10
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.15
        stackView.layer.shadowOffset = CGSize(width: 0, height: -1)
        stackView.layer.shadowRadius = 10
        stackView.layer.masksToBounds = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setConstraints()
        configureSuperview()
        setNotification()
        ProductRepository.shared.calculateTotalCost()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartListContainerView {
    @objc private func checkTotalCost(_ notification: Notification) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        if let totalCost = notification.userInfo?[Constants.NotificationUserInfo.totalCostUpdated] as? Double,
           let formattedString = formatter.string(from: NSNumber(value: totalCost)) {
            DispatchQueue.main.async {
                self.totalCostLabel.text = "₺\(formattedString)"
            }
        }
    }
}

extension CartListContainerView {
    @objc func makeOrderButtonPressed() {
        makeOrderButton.setTitle("", for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.delegate?.makeOrderButtonPressed(totalCost: self.totalCostLabel.text!)
        }
    }
}

extension CartListContainerView {
    private func configureSubviews() {
        makeOrderButton.addSubview(activityIndicator)
        containerView.addArrangedSubview(makeOrderButton)
        containerView.addArrangedSubview(totalCostLabel)
        addSubview(containerView)
    }
}

extension CartListContainerView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: makeOrderButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: makeOrderButton.centerYAnchor),
            
            makeOrderButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.65),
            totalCostLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.35),
        ])
    }
}

extension CartListContainerView {
    private func configureSuperview() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
}

extension CartListContainerView {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkTotalCost), name: Constants.NotificationName.totalCost, object: nil)
    }
}
