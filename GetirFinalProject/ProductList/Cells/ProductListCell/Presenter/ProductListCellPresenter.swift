//
//  ProductListCellPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 16.04.2024.
//

import Foundation

protocol ProductListCellPresenterProtocol: AnyObject {
    func loadCell()
    func addButtonTapped()
    func deleteButtonTapped()
}

final class ProductListCellPresenter {
    private weak var cell: ProductListCellProtocol?
    private let interactor: ProductListCellInteractorProtocol?
    private var presentation: ProductPresentation
    
    init(cell: ProductListCellProtocol, presentation: ProductPresentation, interactor: ProductListCellInteractorProtocol?) {
        self.cell = cell
        self.presentation = presentation
        self.interactor = interactor
    }
}

extension ProductListCellPresenter: ProductListCellPresenterProtocol {
    func deleteButtonTapped() {
        interactor?.deleteProductToCart(product: presentation)
    }
    
    func addButtonTapped() {
        interactor?.addProductToCart(product: presentation)
    }
    
    func loadCell() {
        cell?.setup()
        configureProductName()
        configureProductPrice()
        configureProductAttribute()
        configureProductImage()
        configureAddedCartStatus()
    }
}

extension ProductListCellPresenter {
    private func configureAddedCartStatus() {
        guard let productID = presentation.id else { return }
        interactor?.checkIsAddedToCart(productID: productID)
    }
    
    private func configureProductName() {
        guard let productName = presentation.name else { return }
        cell?.setProductNameLabel(text: productName)
    }
    
    private func configureProductPrice() {
        guard let productPrice = presentation.price else { return }
        cell?.setProductPriceLabel(text: productPrice)
    }
    
    private func configureProductAttribute() {
        guard let productAttribute = presentation.attribute else { return }
        cell?.setProductAttributeLabel(text: productAttribute)
    }
    
    private func configureProductImage() {
        guard let imageURLString = presentation.imageURL,
              let imageURL = URL(string: imageURLString) else { return }
        cell?.setProductImageView(url: imageURL)
    }
}

extension ProductListCellPresenter: ProductListCellInteractorOutputProtocol {
    func deletedProductToCart() {
        cell?.configureDeletedProductsView()
    }
    
    func addedProductToCart() {
        cell?.configureAddedProductsView()
    }
    
    func checkIsAddedToCartOutput(isAdded: Bool) {
        cell?.configureProductAddedCartStatus(isAdded: isAdded)
    }
}
