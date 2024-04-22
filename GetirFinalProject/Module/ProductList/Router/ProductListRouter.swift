//
//  ProductListRouter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import Foundation

enum ProductListRoutes {
    case detail(presentation: ProductPresentation)
    case cart
}

protocol ProductListRouterProtocol: AnyObject {
    func navigate(_ route: ProductListRoutes)
}

final class ProductListRouter {
    weak var viewController: ProductListViewController?
    
    static func createModule() -> ProductListViewController {
        let view = ProductListViewController()
        let interactor = ProductListInteractor()
        let router = ProductListRouter()
        
        let presenter = ProductListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension ProductListRouter: ProductListRouterProtocol {
    func navigate(_ route: ProductListRoutes) {
        switch route {
        case .detail(let presentation):
            let productDetailVC = ProductDetailRouter.createModule(with: presentation)
            viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
        case .cart:
            let cartVC = CartListRouter.createModule()
            viewController?.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
}
