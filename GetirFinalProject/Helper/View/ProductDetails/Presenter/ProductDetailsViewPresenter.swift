//
//  ProductDetailsViewPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 15.04.2024.
//

import UIKit

protocol ProductDetailsViewPresenterProtocol {
    func loadView()
}

final class ProductDetailsViewPresenter {
    weak private var view: ProductDetailsViewProtocol?
    private var presentation: ProductPresentation
    
    init(view: ProductDetailsViewProtocol, presentation: ProductPresentation) {
        self.view = view
        self.presentation = presentation
    }
}

extension ProductDetailsViewPresenter: ProductDetailsViewPresenterProtocol {
    func loadView() {
        setProductNameLabel()
        setProductPriceLabel()
        setProductAttributeLabel()
        setProductImageView()
    }
}

extension ProductDetailsViewPresenter {
    private func setProductNameLabel() {
        guard let productName = presentation.name else {
            return
        }
        view?.configureProductNameLabel(productName)
    }
    
    private func setProductPriceLabel() {
        guard let productPrice = presentation.price else {
            return
        }
        view?.configureProductPriceLabel(productPrice)
    }
    
    private func setProductAttributeLabel() {
        view?.configureProductAttributeLabel(presentation.attribute ?? " ")
    }
    
    private func setProductImageView() {
        guard let imageURLString = presentation.imageURL else {
            return
        }
        let imageURL = URL.string(imageURLString)
        view?.configureProductImageView(with: imageURL)
    }
}
