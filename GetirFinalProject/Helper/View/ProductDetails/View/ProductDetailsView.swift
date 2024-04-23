//
//  ProductDetailsView.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 15.04.2024.
//

import UIKit

protocol ProductDetailsViewProtocol: AnyObject {
    var presenter: ProductDetailsViewPresenter? { get set }
    func configureProductNameLabel(_ text: String)
    func configureProductPriceLabel(_ price: Double)
    func configureProductAttributeLabel(_ text: String)
    func configureProductImageView(with url: URL)
}

final class ProductDetailsView: UIView {
    
    var presenter: ProductDetailsViewPresenter? {
        didSet {
            presenter?.loadView()
        }
    }
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.openSansBold, size: 20)
        label.textColor = UIColor.named(Constants.Colors.appMainColor)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productAttributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.openSansSemibold, size: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.15
        label.layer.shadowOffset = CGSize(width: 0, height: 0.6)
        label.layer.shadowRadius = 0.1
        label.layer.masksToBounds = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        configureSubviews()
        setConstraints()
    }
}

extension ProductDetailsView: ProductDetailsViewProtocol {
    func configureProductNameLabel(_ text: String) {
        productNameLabel.text = text
    }
    
    func configureProductPriceLabel(_ price: Double) {
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
    
    func configureProductAttributeLabel(_ text: String) {
        productAttributeLabel.text = text
    }
    
    func configureProductImageView(with url: URL) {
        productImageView.kf.setImage(with: url)
    }
}

extension ProductDetailsView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: heightAnchor),
            
            productPriceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            productPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            productNameLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 4),
            productNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            productAttributeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 2),
            productAttributeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            productAttributeLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension ProductDetailsView {
    private func configureSubviews() {
        addSubview(productImageView)
        addSubview(productNameLabel)
        addSubview(productPriceLabel)
        addSubview(productAttributeLabel)
    }
}
