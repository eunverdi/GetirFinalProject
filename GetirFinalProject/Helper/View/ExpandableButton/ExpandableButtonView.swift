//
//  ExpandableButton.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 19.04.2024.
//

import UIKit

protocol ExpandableButtonViewProtocol: AnyObject {
    func addProductToBasket()
    func deleteProductFromBasket()
    func updateProductCount(with count: String)
}

final class ExpandableButtonView: UIView {
    weak var delegate: ExpandableButtonViewProtocol?
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                UIView.animate(
                    withDuration: 0.3, delay: 0, options: .curveEaseIn,
                    animations: {
                        self.expandedStackView.subviews.forEach({ $0.isHidden = !$0.isHidden })
                        self.expandedStackView.isHidden = !self.expandedStackView.isHidden
                        let isExpandedStackViewHidden = self.expandedStackView.isHidden
                        if isExpandedStackViewHidden {
                            self.addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                        } else {
                            self.addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        }
                    }
                )
                var countLabelValue = Int(self.countLabel.text!)
                if countLabelValue! >= 1 {
                    self.decrementButton.setImage(UIImage.named(Constants.ImageName.minusButtonIcon), for: .normal)
                    self.decrementButton.tag = 2
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .system)
        let addButtonImage = UIImage.named(Constants.ImageName.plusButtonIcon)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(addButtonImage, for: .normal)
        addButton.backgroundColor = .white
        addButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        addButton.layer.cornerRadius = 10
        if isExpanded {
            addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        addButton.addTarget(self, action: #selector(addButtonPressed(_ :)), for: .touchUpInside)
        return addButton
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textAlignment = .center
        countLabel.text = "0"
        countLabel.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        countLabel.font = UIFont(name: Constants.Fonts.openSansBold, size: 12)!
        countLabel.textColor = .white
        countLabel.isHidden = !isExpanded
        return countLabel
    }()
    
    lazy var decrementButton: UIButton = {
        let decrementButton = UIButton(type: .system)
        let decrementButtonImage = UIImage.named(Constants.ImageName.trashButtonIcon)
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        decrementButton.setImage(decrementButtonImage, for: .normal)
        decrementButton.tintColor = UIColor.named(Constants.Colors.appMainColor)
        decrementButton.isHidden = !isExpanded
        decrementButton.backgroundColor = .white
        decrementButton.layer.cornerRadius = 10
        decrementButton.tag = 1
        decrementButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        decrementButton.addTarget(self, action: #selector(decrementButtonPressed(_ :)), for: .touchUpInside)
        return decrementButton
    }()
    
    lazy var expandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isHidden = !isExpanded
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(decrementButton)
        return stackView
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 10
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.10
        stackView.layer.zPosition = 1
        stackView.layer.shadowOffset = CGSize(width: 0, height: -1)
        stackView.layer.shadowRadius = 10
        stackView.layer.masksToBounds = false
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(expandedStackView)
        return stackView
    }()
    
    private func setConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            
            countLabel.widthAnchor.constraint(equalToConstant: 32),
            countLabel.heightAnchor.constraint(equalToConstant: 32),
            
            decrementButton.widthAnchor.constraint(equalToConstant: 32),
            decrementButton.heightAnchor.constraint(equalToConstant: 32),
            
            containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor)
        ])
    }
}

extension ExpandableButtonView {
    @objc private func addButtonPressed(_ sender: UIButton) {
        
        var countLabelValue = Int(self.countLabel.text!)
        if countLabelValue! >= 1 {
            self.decrementButton.setImage(UIImage.named(Constants.ImageName.minusButtonIcon), for: .normal)
            self.decrementButton.tag = 2
        }
        
        if countLabelValue == 0 {
            UIView.animate(
                withDuration: 0.3, delay: 0, options: .curveEaseIn,
                animations: {
                    self.expandedStackView.subviews.forEach({ $0.isHidden = !$0.isHidden })
                    self.expandedStackView.isHidden = !self.expandedStackView.isHidden
                    let isExpandedStackViewHidden = self.expandedStackView.isHidden
                    if isExpandedStackViewHidden {
                        self.addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                    } else {
                        self.addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    }
                }
            )
            delegate?.addProductToBasket()
        }
        
        countLabelValue! += 1
        self.countLabel.text = "\(countLabelValue!)"
        delegate?.updateProductCount(with: "\(countLabelValue!)")
    }
}

extension ExpandableButtonView {
    @objc private func decrementButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            UIView.animate(
                withDuration: 0.3, delay: 0, options: .curveEaseIn,
                animations: {
                    self.expandedStackView.subviews.forEach({ $0.isHidden = !$0.isHidden })
                    self.expandedStackView.isHidden = !self.expandedStackView.isHidden
                    let isExpandedStackViewHidden = self.expandedStackView.isHidden
                    if isExpandedStackViewHidden {
                        self.addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                    } else {
                        self.addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    }
                }
            )
            delegate?.deleteProductFromBasket()
            defer {
                self.countLabel.text = "0"
            }
        } else {
            var countLabelValue = Int(self.countLabel.text!)
            countLabelValue! -= 1
            self.countLabel.text = "\(countLabelValue!)"
            delegate?.updateProductCount(with: "\(countLabelValue!)")
            
            if countLabelValue! == 1 {
                self.decrementButton.setImage(UIImage.named(Constants.ImageName.trashButtonIcon), for: .normal)
                self.decrementButton.tag = 1
            }
        }
    }
}
