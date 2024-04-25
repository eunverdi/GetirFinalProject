//
//  ProductListCellBuilder.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 16.04.2024.
//

import Foundation

enum ProductListCellBuilder {
    static func createCell(_ cell: ProductListCell, presentation: ProductPresentation) {
        let interactor = ProductListCellInteractor()
        let presenter = ProductListCellPresenter(cell: cell, presentation: presentation, interactor: interactor)
        interactor.output = presenter
        cell.presenter = presenter
    }
}
