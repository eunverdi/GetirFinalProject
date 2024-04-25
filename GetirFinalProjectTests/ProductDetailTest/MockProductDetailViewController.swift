//
//  MockProductDetailViewController.swift
//  GetirFinalProjectTests
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import Foundation
@testable import GetirFinalProject

final class MockHomeDetailViewController: ProductDetailViewControllerProtocol {
    
    var invokedConfigureSubviews = false
    var invokedConfigureSubviewsCount = 0
    
    func configureSubviews() {
        invokedConfigureSubviews = true
        invokedConfigureSubviewsCount += 1
    }
    
    var invokedConfigureSuperview = false
    var invokedConfigureSuperviewCount = 0
    
    func configureSuperview() {
        invokedConfigureSuperview = true
        invokedConfigureSuperviewCount += 1
    }
    
    var invokedConfigureNavigationBar = false
    var invokedConfigureNavigationBarCount = 0
    
    func configureNavigationBar() {
        invokedConfigureNavigationBar = true
        invokedConfigureNavigationBarCount += 1
    }
    
    var invokedConfigureProductStatus = false
    var invokedConfigureProductStatusCount = 0
    var invokedConfigureProductStatusParameters: (productCount: String, Void)?
    
    func configureProductStatus(productCount: String) {
        invokedConfigureProductStatus = true
        invokedConfigureProductStatusCount += 1
        invokedConfigureProductStatusParameters = (productCount, ())
        invokedConfigureProductStatusParametersList.append((productCount, ()))
    }
    
    var invokedSetDelegates = false
    var invokedSetDelegatesCount = 0
    
    func setDelegates() {
        invokedSetDelegates = true
        invokedSetDelegatesCount += 1
    }
}
