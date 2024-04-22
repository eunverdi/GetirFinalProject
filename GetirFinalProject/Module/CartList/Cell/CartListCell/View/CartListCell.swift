//
//  CartListCell.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import UIKit

protocol CartListCellProtocol: AnyObject {
    func setup()
    func setProductNameLabel(text: String)
    func setProductPriceLabel(price: Double)
    func setProductAttributeLabel(text: String)
    func setProductImageView(url: URL)
    func configureStepperView(productCount: String)
}

final class CartListCell: UITableViewCell {
    var presenter: CartListCellPresenterProtocol? {
        didSet {
            presenter?.loadCell()
        }
    }
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        label.textColor = UIColor.named(Constants.Colors.appMainColor)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let productAttributeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.named(Constants.Colors.productImageBorderColor).cgColor
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let labelsStackView: UIStackView = {
        let labelsStackView = UIStackView()
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .fill
        labelsStackView.distribution = .fillProportionally
        labelsStackView.spacing = 0
        return labelsStackView
    }()
    
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.spacing = 2
        return mainStackView
    }()
    
    private let decrementButton: UIButton = {
        let decrementButton = UIButton(type: .system)
        let decrementButtonImage = UIImage.named(Constants.ImageName.trashButtonIcon)
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
}

extension CartListCell: CartListCellProtocol {
    func configureStepperView(productCount: String) {
        countLabel.text = productCount
        guard let productCountIntValue = Int(productCount) else { return }
        if productCountIntValue > 1 {
            let decrementButtonImage = UIImage.named(Constants.ImageName.minusButtonIcon)
            decrementButton.setImage(decrementButtonImage, for: .normal)
            decrementButton.tag = 2
        } else {
            let decrementButtonImage = UIImage.named(Constants.ImageName.trashButtonIcon)
            decrementButton.setImage(decrementButtonImage, for: .normal)
            decrementButton.tag = 1
        }
    }
    
    func setup() {
        backgroundColor = .white
        
        labelsStackView.addArrangedSubview(productNameLabel)
        labelsStackView.addArrangedSubview(productAttributeLabel)
        labelsStackView.addArrangedSubview(productPriceLabel)
        
        stepperButtonView.addArrangedSubview(decrementButton)
        stepperButtonView.addArrangedSubview(countLabel)
        stepperButtonView.addArrangedSubview(incrementButton)
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(labelsStackView)
        mainStackView.addArrangedSubview(stepperButtonView)
        
        addSubview(mainStackView)
        
        setConstraints()
    }
    
    func setProductNameLabel(text: String) {
        productNameLabel.text = text
    }
    
    func setProductPriceLabel(price: Double) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if let formattedString = formatter.string(from: NSNumber(value: price)) {
            DispatchQueue.main.async {
                self.productPriceLabel.text = "₺\(formattedString)"
            }
        }
    }
    
    func setProductAttributeLabel(text: String) {
        productAttributeLabel.text = text
    }
    
    func setProductImageView(url: URL) {
        productImageView.kf.setImage(with: url)
    }
    
    func configureAddedProductsCount(count: String) {
        countLabel.text = count
    }
}

extension CartListCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            productImageView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            productImageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.25),
            productImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor),
            
            labelsStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 8.5),
            labelsStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            labelsStackView.trailingAnchor.constraint(equalTo: stepperButtonView.leadingAnchor, constant: -8.5),
            labelsStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -12),
            
            stepperButtonView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor),
            stepperButtonView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            stepperButtonView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.3),
            stepperButtonView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.4)
        ])
    }
}

extension CartListCell {
    @objc private func incrementButtonPressed() {
        guard let countLabelText = self.countLabel.text,
              var countLabelValue = Int(countLabelText) else { return }
        countLabelValue += 1
        let valueStringFormat = String(countLabelValue)
        presenter?.updateCount(with: valueStringFormat)
    }
    
    @objc private func decrementButtonPressed() {
        let buttonStatus = decrementButton.tag
        if buttonStatus == 1 {
            presenter?.deleteProduct()
        } else {
            guard let countLabelText = self.countLabel.text,
                  var countLabelValue = Int(countLabelText) else { return }
            countLabelValue -= 1
            let valueStringFormat = String(countLabelValue)
            presenter?.updateCount(with: valueStringFormat)
        }
    }
}
