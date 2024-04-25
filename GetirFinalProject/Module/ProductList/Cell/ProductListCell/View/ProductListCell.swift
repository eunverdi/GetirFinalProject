//
//  ProductListCell.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 13.04.2024.
//

import UIKit
import SDWebImage

protocol ProductListCellProtocol: AnyObject {
    func setup()
    func setProductNameLabel(text: String)
    func setProductPriceLabel(price: Double)
    func setProductAttributeLabel(text: String)
    func setProductImageView(url: URL)
    func configureProductAddedCartStatus(isAdded: Bool)
    func configureDeletedProductsView()
    func configureAddedProductsView()
    func configureAddedProductsCount(count: String)
}

final class ProductListCell: UICollectionViewCell {
    var presenter: ProductListCellPresenterProtocol? {
        didSet {
            presenter?.loadCell()
        }
    }

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        label.textColor = UIColor.named(Constants.Colors.appMainColor)
        label.numberOfLines = 1
        return label
    }()
    
    private let productAttributeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.textColor = .lightGray
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
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 1
        return labelsStackView
    }()
    
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing = 2
        return mainStackView
    }()
    
    private lazy var addToCartButton: UIButton = {
        let addButton = UIButton(type: .system)
        let addButtonImage = UIImage.named(Constants.ImageName.plusButtonIcon)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(addButtonImage, for: .normal)
        addButton.backgroundColor = .white
        addButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        addButton.layer.cornerRadius = 10
        addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.10
        addButton.layer.zPosition = 1
        addButton.layer.shadowOffset = CGSize(width: 0, height: -1)
        addButton.layer.shadowRadius = 10
        addButton.layer.masksToBounds = false
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var incrementButton: UIButton = {
        let addButton = UIButton(type: .system)
        let addButtonImage = UIImage.named(Constants.ImageName.plusButtonIcon)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(addButtonImage, for: .normal)
        addButton.backgroundColor = .white
        addButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        addButton.layer.cornerRadius = 10
        addButton.isHidden = true
        addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 10
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.10
        stackView.layer.zPosition = 2
        stackView.layer.shadowOffset = CGSize(width: 0, height: -1)
        stackView.layer.shadowRadius = 10
        stackView.layer.masksToBounds = false
        stackView.isHidden = true
        stackView.addArrangedSubview(incrementButton)
        stackView.addArrangedSubview(expandedStackView)
        return stackView
    }()
    
    private lazy var expandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isHidden = true
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(decrementButton)
        return stackView
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textAlignment = .center
        countLabel.text = "0"
        countLabel.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        countLabel.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)
        countLabel.textColor = .white
        countLabel.isHidden = true
        return countLabel
    }()
    
    private lazy var decrementButton: UIButton = {
        let decrementButton = UIButton(type: .system)
        let decrementButtonImage = UIImage.named(Constants.ImageName.trashButtonIcon)
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        decrementButton.setImage(decrementButtonImage, for: .normal)
        decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        decrementButton.isHidden = true
        decrementButton.backgroundColor = .white
        decrementButton.layer.cornerRadius = 10
        decrementButton.tag = 1
        decrementButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        decrementButton.addTarget(self, action: #selector(decrementButtonPressed(_ :)), for: .touchUpInside)
        return decrementButton
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productNameLabel.text = nil
        productPriceLabel.text = nil
        productAttributeLabel.text = nil
        productImageView.image = nil
        countLabel.text = "0"
        productImageView.layer.sublayers?.removeAll()
        productImageView.layer.borderColor = UIColor.named(Constants.Colors.sectionHeaderColor).cgColor
        decrementButton.tag = 1
        decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
    }
}

extension ProductListCell: ProductListCellProtocol {
    func configureAddedProductsCount(count: String) {
        guard let value = Int(count) else {
            return
        }
        if value >= 1 {
            self.addToCartButton.isHidden = false
            self.countLabel.text = "\(count)"
            self.decrementButton.setImage(UIImage.named(Constants.ImageName.minusButtonIcon), for: .normal)
            self.decrementButton.tag = 2
            if value == 1 {
                self.decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
                self.decrementButton.tag = 1
            }
        }
    }
    
    func setup() {
        backgroundColor = .white
        
        labelsStackView.addArrangedSubview(productPriceLabel)
        labelsStackView.addArrangedSubview(productNameLabel)
        labelsStackView.addArrangedSubview(productAttributeLabel)
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(labelsStackView)
        
        addSubview(mainStackView)
        addSubview(addToCartButton)
        addSubview(containerStackView)

        setConstraints()
    }
    
    func configureProductAddedCartStatus(isAdded: Bool) {
        if isAdded {
            self.productImageView.layer.borderColor = UIColor.named(Constants.Colors.appMainColor).cgColor
            self.incrementButton.isHidden = false
            self.decrementButton.isHidden = false
            self.countLabel.isHidden = false
            self.containerStackView.isHidden = false
            self.expandedStackView.isHidden = false
        } else {
            self.productImageView.layer.borderColor = UIColor.named(Constants.Colors.productImageBorderColor).cgColor
            self.productImageView.layer.sublayers?.removeAll()
            self.decrementButton.isHidden = true
            self.countLabel.isHidden = true
            self.containerStackView.isHidden = true
            self.expandedStackView.isHidden = true
        }
    }
    
    func setProductNameLabel(text: String) {
        productNameLabel.text = text
    }
    
    func setProductPriceLabel(price: Double) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
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
        productImageView.sd_setImage(with: url)
    }
    
    func configureDeletedProductsView() {
        productImageView.layer.sublayers?.removeAll()
        productImageView.layer.borderColor = UIColor.named(Constants.Colors.productImageBorderColor).cgColor
    }
    
    func configureAddedProductsView() {
        configureCellAnimation()
    }
}

extension ProductListCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            addToCartButton.widthAnchor.constraint(equalToConstant: 32),
            addToCartButton.heightAnchor.constraint(equalToConstant: 32),
            addToCartButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            
            incrementButton.widthAnchor.constraint(equalToConstant: 32),
            incrementButton.heightAnchor.constraint(equalToConstant: 32),
            
            countLabel.widthAnchor.constraint(equalToConstant: 32),
            countLabel.heightAnchor.constraint(equalToConstant: 32),
            
            decrementButton.widthAnchor.constraint(equalToConstant: 32),
            decrementButton.heightAnchor.constraint(equalToConstant: 32),
            
            containerStackView.widthAnchor.constraint(equalToConstant: 32),
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3)
        ])
    }
}

extension ProductListCell {
    private func configureCellAnimation() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.named(Constants.Colors.appMainColor).cgColor
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: productImageView.frame, cornerRadius: productImageView.layer.cornerRadius).cgPath
        borderLayer.lineWidth = 1.5
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.6
        
        borderLayer.add(animation, forKey: "line")
        productImageView.layer.addSublayer(borderLayer)
    }
}

extension ProductListCell {
    @objc private func addButtonPressed() {
        guard let countLabelText = self.countLabel.text, var countLabelIntValue = Int(countLabelText) else {
            return
        }
  
        if countLabelIntValue >= 1 {
            self.decrementButton.setImage(UIImage.named(Constants.ImageName.minusButtonIcon), for: .normal)
            self.decrementButton.tag = 2
        }
        
        if countLabelIntValue == 0 {
            self.decrementButton.isHidden = false
            self.countLabel.isHidden = false
            self.containerStackView.isHidden = false
            self.expandedStackView.isHidden = false
            self.incrementButton.isHidden = false
            presenter?.addButtonTapped()
        }
        
        countLabelIntValue += 1
        self.countLabel.text = "\(countLabelIntValue)"
        presenter?.updateCount(with: "\(countLabelIntValue)")
    }
}

extension ProductListCell {
    @objc private func decrementButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            self.decrementButton.isHidden = true
            self.countLabel.isHidden = true
            self.containerStackView.isHidden = true
            self.expandedStackView.isHidden = true
            self.incrementButton.isHidden = true
            self.countLabel.text = "0"
            presenter?.deleteButtonTapped()
        } else {
            guard let countLabelText = self.countLabel.text, var countLabelIntValue = Int(countLabelText) else {
                return
            }
            
            countLabelIntValue -= 1
            self.countLabel.text = "\(countLabelIntValue)"
            presenter?.updateCount(with: "\(countLabelIntValue)")
            
            if countLabelIntValue == 1 {
                self.decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
                self.decrementButton.tag = 1
            }
        }
    }
}
