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
    func setProductPriceLabel(text: String)
    func setProductAttributeLabel(text: String)
    func setProductImageView(url: URL)
    func configureProductAddedCartStatus(isAdded: Bool)
    func configureDeletedProductsView()
    func configureAddedProductsView()
}

final class ProductListCell: UICollectionViewCell {
    
    static let identifier = String(describing: ProductListCell.self)
    
    var presenter: ProductListCellPresenterProtocol? {
        didSet {
            presenter?.loadCell()
        }
    }
    
    private let decrementButton: UIButton = {
        let decrementButton = UIButton(type: .system)
        let decrementButtonImage = UIImage(named: "trashButtonIcon")
        decrementButton.setImage(decrementButtonImage, for: .normal)
        decrementButton.tintColor = Constants.Colors.appMainColor
        decrementButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        decrementButton.layer.cornerRadius = 10
        decrementButton.tag = 1
        decrementButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return decrementButton
    }()
    
    private let incrementButton: UIButton = {
        let incrementButton = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        let incrementButtonImage = UIImage(named: "plusButtonIcon")
        incrementButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        incrementButton.setImage(incrementButtonImage, for: .normal)
        incrementButton.backgroundColor = .white
        incrementButton.tintColor = Constants.Colors.appMainColor
        incrementButton.layer.cornerRadius = 10
        incrementButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return incrementButton
    }()
    
    private let countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.textAlignment = .center
        countLabel.backgroundColor = Constants.Colors.appMainColor
        countLabel.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)
        countLabel.textColor = .white
        return countLabel
    }()
    
    private let stepperButtonView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 10
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.10
        stackView.layer.zPosition = 1
        stackView.layer.shadowOffset = CGSize(width: 0, height: -1)
        stackView.layer.shadowRadius = 10
        stackView.layer.masksToBounds = false
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let label = UIButton(type: .system)
        label.setTitle("Ekle", for: .normal)
        label.backgroundColor = .green
        label.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
        let label = UIButton(type: .system)
        label.setTitle("Sil", for: .normal)
        label.backgroundColor = .red
        label.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        label.textColor = Constants.Colors.appMainColor
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productAttributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = Constants.Colors.productImageBorderColor?.cgColor
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    private let labelsStackView: UIStackView = {
        let labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .fill
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 1
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelsStackView
    }()
    
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing = 2
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        return mainStackView
    }()
    
    
    @objc private func addTapped() {
        presenter?.addButtonTapped()
        heightConstraint?.isActive = false
        heightConstraint = stepperButtonView.heightAnchor.constraint(equalToConstant: 96)
        heightConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.stepperButtonView.addArrangedSubview(self.countLabel)
            self.stepperButtonView.addArrangedSubview(self.decrementButton)
            self.stepperButtonView.layoutIfNeeded()
        })
    }
    
    @objc private func deleteTapped() {
        presenter?.deleteButtonTapped()
    }

    var heightConstraint: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        heightConstraint = stepperButtonView.heightAnchor.constraint(equalToConstant: 32)
        heightConstraint?.isActive = true
    }
    
    override func prepareForReuse() {
        productNameLabel.text = nil
        productPriceLabel.text = nil
        productAttributeLabel.text = nil
        productImageView.image = nil
        productImageView.layer.borderColor = Constants.Colors.productImageBorderColor?.cgColor
        productImageView.layer.sublayers?.removeAll()
    }
}

extension ProductListCell: ProductListCellProtocol {
    func setup() {
        backgroundColor = .white
        
        labelsStackView.addArrangedSubview(productPriceLabel)
        labelsStackView.addArrangedSubview(productNameLabel)
        labelsStackView.addArrangedSubview(productAttributeLabel)
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(labelsStackView)
        
        addSubview(mainStackView)
        
        stepperButtonView.addArrangedSubview(incrementButton)
//        stepperButtonView.addArrangedSubview(countLabel)
//        stepperButtonView.addArrangedSubview(decrementButton)
        addSubview(stepperButtonView)

        setConstraints()
    }
    
    func configureProductAddedCartStatus(isAdded: Bool) {
        if isAdded {
            self.productImageView.layer.borderColor = Constants.Colors.appMainColor?.cgColor
        }
    }
    
    func setProductNameLabel(text: String) {
        productNameLabel.text = text
    }
    
    func setProductPriceLabel(text: String) {
        productPriceLabel.text = text
    }
    
    func setProductAttributeLabel(text: String) {
        productAttributeLabel.text = text
    }
    
    func setProductImageView(url: URL) {
        productImageView.sd_setImage(with: url)
    }
    
    func configureDeletedProductsView() {
        productImageView.layer.sublayers?.removeAll()
        productImageView.layer.borderColor = Constants.Colors.productImageBorderColor?.cgColor
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
            
            stepperButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            stepperButtonView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stepperButtonView.widthAnchor.constraint(equalToConstant: 32),
        ])
    }
}

extension ProductListCell {
    private func configureCellAnimation() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = Constants.Colors.appMainColor?.cgColor
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: productImageView.frame,
                                        cornerRadius: productImageView.layer.cornerRadius).cgPath
        borderLayer.lineWidth = 1.5
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.6
        
        borderLayer.add(animation, forKey: "line")
        productImageView.layer.addSublayer(borderLayer)
    }
}
