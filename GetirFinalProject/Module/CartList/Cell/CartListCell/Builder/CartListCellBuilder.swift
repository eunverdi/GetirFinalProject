//
//  CartListCellBuilder.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

final class CartListCellBuilder {
    static func createCell(_ cell: CartListCell, presentation: ProductPresentation) {
        let interactor = CartListCellInteractor()
        let presenter = CartListCellPresenter(cell: cell, interactor: interactor, presentation: presentation)
        interactor.output = presenter
        cell.presenter = presenter
    }
}
