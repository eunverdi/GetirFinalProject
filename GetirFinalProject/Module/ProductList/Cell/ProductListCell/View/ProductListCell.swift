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
    
    private lazy var expandableButtonView: ExpandableButtonView = {
        let view = ExpandableButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.layer.zPosition = 1
        return view
    }()
    
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
    
    @objc private func addTapped() {
        presenter?.addButtonTapped()
    }
    
    private func updateCount(count: String) {
        presenter?.updateCount(with: count)
    }
    
    @objc private func deleteTapped() {
        presenter?.deleteButtonTapped()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        productNameLabel.text = nil
        productPriceLabel.text = nil
        productAttributeLabel.text = nil
        productImageView.image = nil
        productImageView.layer.borderColor = UIColor.named(Constants.Colors.productImageBorderColor).cgColor
        productImageView.layer.sublayers?.removeAll()
        expandableButtonView.isExpanded = false
    }
}

extension ProductListCell: ProductListCellProtocol {
    func configureAddedProductsCount(count: String) {
        let value = Int(count)!
        if value >= 1 {
            self.expandableButtonView.countLabel.text = "\(value)"
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
        addSubview(expandableButtonView)

        setConstraints()
    }
    
    func configureProductAddedCartStatus(isAdded: Bool) {
        if isAdded {
            self.productImageView.layer.borderColor = UIColor.named(Constants.Colors.appMainColor).cgColor
            self.expandableButtonView.isExpanded = true
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
            
            expandableButtonView.widthAnchor.constraint(equalToConstant: 32),
            expandableButtonView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            expandableButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
        ])
    }
}

extension ProductListCell {
    private func configureCellAnimation() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.named(Constants.Colors.appMainColor).cgColor
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

extension ProductListCell: ExpandableButtonViewProtocol {
    func updateProductCount(with count: String) {
        updateCount(count: count)
    }
    
    func addProductToBasket() {
        addTapped()
    }
    
    func deleteProductFromBasket() {
        deleteTapped()
    }
}
