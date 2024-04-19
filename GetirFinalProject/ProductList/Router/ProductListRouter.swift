//
//  ProductListRouter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import Foundation

enum ProductListRoutes {
    case detail(presentation: ProductPresentation)
    case basket
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
            let productDetail = ProductDetailRouter.createModule(with: presentation)
            viewController?.navigationController?.pushViewController(productDetail, animated: true)
        case .basket: break
        }
    }
}
