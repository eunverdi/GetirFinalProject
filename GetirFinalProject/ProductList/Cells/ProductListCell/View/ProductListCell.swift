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
    
    private lazy var expandableButtonView: ExpandableButtonView = {
        let view = ExpandableButtonView()
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(expandableButtonView)

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
            
            expandableButtonView.widthAnchor.constraint(equalToConstant: 32),
            expandableButtonView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            expandableButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
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
