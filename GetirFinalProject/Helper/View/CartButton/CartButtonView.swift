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
    
    static let shared = CartButtonView()
    weak var delegate: CartButtonViewProtocol?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "cartButtonIcon")
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "₺0,00"
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)
        lbl.textColor = Constants.Colors.appMainColor
        lbl.textAlignment = .center
        lbl.backgroundColor = Constants.Colors.productImageBorderColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.clipsToBounds = true
        return sv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalCost(_:)), name: NSNotification.Name("TotalCostUpdated"), object: nil)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressed)))
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
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
        
        ProductRepository.shared.calculateTotalCost()
    }
    
    @objc func updateTotalCost(_ notification: Notification) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        if let totalCost = notification.userInfo?["totalCost"] as? Double,
           let formattedString = formatter.string(from: NSNumber(value: totalCost)) {
            DispatchQueue.main.async {
                self.label.text = "₺\(formattedString)"
                if formattedString.count > 8 {
                    self.label.font = UIFont(name: Constants.Fonts.openSansBold, size: 10)
                } else {
                    self.label.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)
                }
            }
        }
        
//        defer {
//            if self.label.text == "₺0,00" {
//                isUserInteractionEnabled = false
//            } else {
//                isUserInteractionEnabled = true
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pressed() {
        delegate?.cartButtonPressed()
    }
}


