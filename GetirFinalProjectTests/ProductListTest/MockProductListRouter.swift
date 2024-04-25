//
//  MockProductListRouter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import UIKit
@testable import GetirFinalProject

final class MockProductListRouter: ProductListRouterProtocol {
    
    var invokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (route: ProductListRoutes, Void)?

    func navigate(_ route: ProductListRoutes) {
        invokedNavigate = true
        invokedNavigateCount += 1
        invokedNavigateParameters = (route, ())
    }
}
