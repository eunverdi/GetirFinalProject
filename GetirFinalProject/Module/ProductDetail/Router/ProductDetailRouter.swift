//
//  ProductDetailRouter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import Foundation

enum ProductDetailRoutes {
    case productList
    case cart
}

protocol ProductDetailRouterProtocol: AnyObject {
    func navigate(_ route: ProductDetailRoutes)
}

final class ProductDetailRouter {
    weak var viewController: ProductDetailViewController?
    
    static func createModule(with presentation: ProductPresentation) -> ProductDetailViewController {
        let view = ProductDetailViewController()
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()
        let presenter = ProductDetailPresenter(view: view, interactor: interactor, router: router, presentation: presentation)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ProductDetailRouter: ProductDetailRouterProtocol {
    func navigate(_ route: ProductDetailRoutes) {
        switch route {
        case .productList:
            viewController?.navigationController?.popViewController(animated: true)
        case .cart:
            let cartVC = CartListRouter.createModule()
            viewController?.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
}
