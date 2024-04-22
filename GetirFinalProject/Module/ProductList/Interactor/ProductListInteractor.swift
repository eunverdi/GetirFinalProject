//
//  ProductListInteractor.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import Foundation

protocol ProductListInteractorOutputProtocol: AnyObject {
    func fetchVerticalListProductsOutputs(_ result: Result<[VListProductModel], Error>)
    func fetchHorizontalListProductsOutputs(_ result: Result<[HListProductsModel], Error>)
}

protocol ProductListInteractorProtocol {
    func fetchProducts()
}

final class ProductListInteractor {
    weak var output: ProductListInteractorOutputProtocol?
    private let networkManager = NetworkManager()
}

extension ProductListInteractor: ProductListInteractorProtocol {
    func fetchProducts() {
        networkManager.getVerticalListProducts { [output] result in
            output?.fetchVerticalListProductsOutputs(result)
        }
        
        networkManager.getHorizontalListProducts { [output] result in
            output?.fetchHorizontalListProductsOutputs(result)
        }
    }
}
