//
//  CartListRouter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

enum CartListRoutes {
    case back
    case productList
}

protocol CartListRouterProtocol: AnyObject {
    func navigate(_ route: CartListRoutes)
}

final class CartListRouter {
    weak var viewController: CartListViewController?
    
    static func createModule() -> CartListViewController {
        let view = CartListViewController()
        let interactor = CartListInteractor()
        let router = CartListRouter()
        let presenter = CartListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension CartListRouter: CartListRouterProtocol {
    func navigate(_ route: CartListRoutes) {
        switch route {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        case .productList:
            let productListVC = ProductListRouter.createModule()
            viewController?.navigationController?.pushViewController(productListVC, animated: true)
        }
    }
}
