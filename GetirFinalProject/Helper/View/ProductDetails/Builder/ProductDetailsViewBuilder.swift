//
//  ProductDetailsViewBuilder.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 15.04.2024.
//

import Foundation

final class ProductDetailsViewBuilder {
    static func createView(_ view: ProductDetailsView, presentation: ProductPresentation) {
        view.presenter = ProductDetailsViewPresenter(view: view, presentation: presentation)
    }
}
