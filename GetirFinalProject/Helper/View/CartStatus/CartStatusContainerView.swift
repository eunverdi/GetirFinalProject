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
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        button.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addToCartButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let decrementButton: UIButton = {
        let decrementButton = UIButton(type: .system)
        let decrementButtonImage = UIImage.named("trashButtonIcon")
        decrementButton.setImage(decrementButtonImage, for: .normal)
        decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        decrementButton.addTarget(self, action: #selector(decrementButtonPressed), for: .touchUpInside)
        decrementButton.layer.cornerRadius = 10
        decrementButton.tag = 1
        decrementButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return decrementButton
    }()
    
    private let incrementButton: UIButton = {
        let incrementButton = UIButton(type: .system)
        let incrementButtonImage = UIImage.named("plusButtonIcon")
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
    
    func configureComponents(productCount: String) {
        let value = Int(productCount)
        
        if value! >= 1 {
            self.addToCartButton.isHidden = true
            self.stepperButtonView.isHidden = false
            if value! == 1 {
                self.decrementButton.setImage(UIImage.named("trashButtonIcon"), for: .normal)
            } else {
                self.decrementButton.setImage(UIImage.systemName("minus").withTintColor(UIColor.named(Constants.Colors.appMainColor), renderingMode: .alwaysTemplate), for: .normal)
            }
            self.decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
            self.countLabel.text = productCount
        }
    }
    
    @objc func incrementButtonPressed() {
        if var value = Int(countLabel.text ?? "1") {
            value += 1
            countLabel.text = "\(value)"
            delegate?.updateProductCount(with: "\(value)")
            
            if value != 1 {
                decrementButton.setImage(UIImage.systemName("minus").withTintColor(UIColor.named(Constants.Colors.appMainColor), renderingMode: .alwaysTemplate), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
            } else {
                decrementButton.setImage(UIImage.named("trashButtonIcon"), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
            }
        }
    }
    
    @objc func decrementButtonPressed() {
        if var value = Int(countLabel.text ?? "1") {
            value -= 1
            countLabel.text = "\(value)"
            delegate?.updateProductCount(with: "\(value)")
            
            if decrementButton.tag == 2 {
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                
                addToCartButton.setTitle("Sepete Ekle", for: .normal)
                addToCartButton.isHidden = false
                stepperButtonView.isHidden = true
                countLabel.text = "1"
                decrementButton.tag = 1
            } else if decrementButton.tag == 3 {
                addToCartButton.setTitle("Sepete Ekle", for: .normal)
                addToCartButton.isHidden = false
                stepperButtonView.isHidden = true
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                countLabel.text = "1"
                decrementButton.tag = 1
                delegate?.deleteProductFromCart()
            }
            
            if value != 1 {
                decrementButton.setImage(UIImage.systemName("minus").withTintColor(UIColor.named(Constants.Colors.appMainColor), renderingMode: .alwaysTemplate), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
            } else if value == 1 {
                decrementButton.tag = 3
                decrementButton.setImage(UIImage.named("trashButtonIcon"), for: .normal)
                decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
            }
        }
    }
    
    @objc func addToCartButtonPressed() {
        addToCartButton.setTitle("", for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.addToCartButton.isHidden = true
            self.stepperButtonView.isHidden = false
            self.decrementButton.setImage(UIImage.named("trashButtonIcon"), for: .normal)
            self.decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        }
        
        delegate?.addProductToCart()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stepperButtonView.addArrangedSubview(decrementButton)
        stepperButtonView.addArrangedSubview(countLabel)
        stepperButtonView.addArrangedSubview(incrementButton)
        addSubview(addToCartButton)
        addSubview(stepperButtonView)
        addToCartButton.addSubview(activityIndicator)
        
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
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
