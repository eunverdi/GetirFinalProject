//
//  CartListCellPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

protocol CartListCellPresenterProtocol: AnyObject {
    func loadCell()
    func updateCount(with count: String)
    func deleteProduct()
}

final class CartListCellPresenter {
    private weak var cell: CartListCellProtocol?
    private let interactor: CartListCellInteractorProtocol?
    private var presentation: ProductPresentation
    private var indexPath: IndexPath?
    
    init(cell: CartListCellProtocol?, interactor: CartListCellInteractorProtocol?, presentation: ProductPresentation, indexPath: IndexPath?) {
        self.cell = cell
        self.interactor = interactor
        self.presentation = presentation
        self.indexPath = indexPath
    }
}

extension CartListCellPresenter: CartListCellPresenterProtocol {
    func updateCount(with count: String) {
        presentation.currentAmount = count
        interactor?.updateProductCount(product: presentation)
    }
    
    func deleteProduct() {
        interactor?.deleteProductToCart(product: presentation)
    }
    
    func loadCell() {
        cell?.setup()
        configureProductName()
        configureProductPrice()
        configureProductAttribute()
        configureProductImage()
        configureStepperView()
    }
}

extension CartListCellPresenter {
    private func configureProductName() {
        guard let productName = presentation.name else {
            return
        }
        cell?.setProductNameLabel(text: productName)
    }
    
    private func configureProductPrice() {
        guard let productPrice = presentation.price, let currentAmount = presentation.currentAmount, let productAmonut = Double(currentAmount) else {
            return
        }
        let totalCost = productPrice * productAmonut
        cell?.setProductPriceLabel(price: totalCost)
    }
    
    private func configureProductAttribute() {
        guard let productAttribute = presentation.attribute else {
            return
        }
        cell?.setProductAttributeLabel(text: productAttribute)
    }
    
    private func configureProductImage() {
        guard let imageURLString = presentation.imageURL else {
            return
        }
        let imageURL = URL.string(imageURLString)
        cell?.setProductImageView(url: imageURL)
    }
    
    private func configureStepperView() {
        guard let productCount = presentation.currentAmount else {
            return
        }
        cell?.configureStepperView(productCount: productCount)
    }
}

extension CartListCellPresenter: CartListCellInteractorOutputProtocol {
    func deletedProductToCart() {
        guard let indexPath = indexPath else {
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name("deleteProduct"), object: nil, userInfo: ["indexPath": indexPath])
    }
    
    func productCountFromCart(count: String) {
        configureProductPrice()
        cell?.configureStepperView(productCount: count)
    }
}
