//
//  CartListCellBuilder.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

enum CartListCellBuilder {
    static func createCell(_ cell: CartListCell, presentation: ProductPresentation, indexPath: IndexPath) {
        let interactor = CartListCellInteractor()
        let presenter = CartListCellPresenter(cell: cell, interactor: interactor, presentation: presentation, indexPath: indexPath)
        interactor.output = presenter
        cell.presenter = presenter
    }
}
