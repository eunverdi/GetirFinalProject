//
//  ProductDetailPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad(detailsView: ProductDetailsView)
    func backButtonPressed()
}

final class ProductDetailPresenter {
    weak private var view: ProductDetailViewControllerProtocol?
    private let interactor: ProductDetailInteractorProtocol?
    private let router: ProductDetailRouterProtocol?
    
    private var presentation: ProductPresentation?
    
    init(view: ProductDetailViewControllerProtocol?,
         interactor: ProductDetailInteractorProtocol?,
         router: ProductDetailRouterProtocol?,
         presentation: ProductPresentation?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.presentation = presentation
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func viewDidLoad(detailsView: ProductDetailsView) {
        guard let presentation = presentation else {
            return //MARK: error yaz
        }
        ProductDetailsViewBuilder.createView(detailsView, presentation: presentation)
        view?.configureSubviews()
        view?.configureNavigationBar()
        view?.configureSuperview()
    }
    
    func backButtonPressed() {
        router?.navigate(.productList)
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {}
