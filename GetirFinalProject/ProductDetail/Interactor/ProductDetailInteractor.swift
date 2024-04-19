//
//  ProductDetailInteractor.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import Foundation

protocol ProductDetailInteractorOutputProtocol: AnyObject {
//    func fetchVerticalListProductsOutputs(_ result: Result<[VListProductModel], Error>)
//    func fetchHorizontalListProductsOutputs(_ result: Result<[HListProductsModel], Error>)
}

protocol ProductDetailInteractorProtocol {
    func fetchProducts()
}

final class ProductDetailInteractor {
    weak var output: ProductDetailInteractorOutputProtocol?
    
}


extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    func fetchProducts() {
        //
    }
}
