//
//  CartStatusContainerView.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 16.04.2024.
//

import UIKit

protocol CartStatusProtocol: AnyObject {
    func updateProductCount(with count: String)
    func addProductToCart()
    func deleteProductFromCart()
}

final class CartStatusContainerView: UIView {
    
    weak var delegate: CartStatusProtocol?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        view.color = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.ButtonTitle.addToCartButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        button.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addToCartButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let decrementButton: UIButton = {
        let decrementButton = UIButton(type: .system)
        let decrementButtonImage = UIImage.named(Constants.ImageName.trashButtonIcon)
        decrementButton.setImage(decrementButtonImage, for: .normal)
        decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        decrementButton.addTarget(self, action: #selector(decrementButtonPressed), for: .touchUpInside)
        decrementButton.layer.cornerRadius = 10
        decrementButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return decrementButton
    }()
    
    private let incrementButton: UIButton = {
        let incrementButton = UIButton(type: .system)
        let incrementButtonImage = UIImage.named(Constants.ImageName.plusButtonIcon)
        incrementButton.addTarget(self, action: #selector(incrementButtonPressed), for: .touchUpInside)
        incrementButton.setImage(incrementButtonImage, for: .normal)
        incrementButton.backgroundColor = .white
        incrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        incrementButton.layer.cornerRadius = 10
        incrementButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return incrementButton
    }()
    
    private let countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "1"
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        countLabel.font = UIFont(name: Constants.Fonts.openSansBold, size: 16)
        countLabel.textColor = .white
        return countLabel
    }()
    
    private let stepperButtonView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.layer.cornerRadius = 10
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        stackView.distribution = .fillEqually
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
        configureViews()
        setConstraints()
        configureSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartStatusContainerView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: addToCartButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            
            addToCartButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addToCartButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            
            stepperButtonView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stepperButtonView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stepperButtonView.widthAnchor.constraint(equalToConstant: 150),
            stepperButtonView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension CartStatusContainerView {
    private func configureSuperview() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
}

extension CartStatusContainerView {
    private func configureViews() {
        stepperButtonView.addArrangedSubview(decrementButton)
        stepperButtonView.addArrangedSubview(countLabel)
        stepperButtonView.addArrangedSubview(incrementButton)
        addSubview(addToCartButton)
        addSubview(stepperButtonView)
        addToCartButton.addSubview(activityIndicator)
    }
}

extension CartStatusContainerView {
    func configureComponents(productCount: String) {
        let value = Int(productCount)
        if let value = value {
            if value >= 1 {
                self.addToCartButton.isHidden = true
                self.stepperButtonView.isHidden = false
                
                if value == 1 {
                    self.decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
                    self.decrementButton.tag = 1
                } else {
                    self.decrementButton.setImage(UIImage.named(Constants.ImageName.minusButtonIcon).withTintColor(UIColor.named(Constants.Colors.appMainColor), renderingMode: .alwaysTemplate), for: .normal)
                    self.decrementButton.tag = 2
                }
                
                self.decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
                self.countLabel.text = productCount
            }
        }
    }
}

extension CartStatusContainerView {
    @objc func incrementButtonPressed() {
        guard let productCount = countLabel.text else { return }
        if var value = Int(productCount) {
            value += 1
            countLabel.text = "\(value)"
            delegate?.updateProductCount(with: "\(value)")
            
            if value != 1 {
                decrementButton.setImage(UIImage.named(Constants.ImageName.minusButtonIcon).withTintColor(UIColor.named(Constants.Colors.appMainColor), renderingMode: .alwaysTemplate), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
                decrementButton.tag = 2
            } else {
                decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
                decrementButton.tag = 1
            }
        }
    }
}

extension CartStatusContainerView {
    @objc func decrementButtonPressed() {
        guard let productCount = countLabel.text else { return }
        if var value = Int(productCount) {
            value -= 1
            countLabel.text = "\(value)"
            delegate?.updateProductCount(with: "\(value)")
           
            let buttonStatus = decrementButton.tag
            if value != 1 {
                decrementButton.setImage(UIImage.named(Constants.ImageName.minusButtonIcon).withTintColor(UIColor.named(Constants.Colors.appMainColor), renderingMode: .alwaysTemplate), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
                decrementButton.tag = 2
            } else if value == 1 {
                decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
                decrementButton.tag = 1
            }
            
            switch buttonStatus {
            case 1:
                addToCartButton.setTitle(Constants.ButtonTitle.addToCartButtonTitle, for: .normal)
                addToCartButton.isHidden = false
                stepperButtonView.isHidden = true
                activityIndicator.isHidden = true
                countLabel.text = "1"
                delegate?.deleteProductFromCart()
                return
            default:
                return
            }
        }
    }
}

extension CartStatusContainerView {
    @objc func addToCartButtonPressed() {
        addToCartButton.setTitle("", for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.activityIndicator.stopAnimating()
            self.addToCartButton.isHidden = true
            self.stepperButtonView.isHidden = false
            self.decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
            self.decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
            self.decrementButton.tag = 1
            self.delegate?.addProductToCart()
        }
    }
}
