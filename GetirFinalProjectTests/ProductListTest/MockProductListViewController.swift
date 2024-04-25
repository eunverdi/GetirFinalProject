//
//  MockProductListViewController.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import UIKit
@testable import GetirFinalProject

final class MockProductListViewController: ProductListViewControllerProtocol {
    
    var invokedPrepareViewDidLoad = false
    var invokedPrepareViewDidLoadCount = 0

    func prepareViewDidLoad() {
        invokedPrepareViewDidLoad = true
        invokedPrepareViewDidLoadCount += 1
    }

    var invokedReloadData = false
    var invokedReloadDataCount = 0

    func reloadData() {
        invokedReloadData = true
        invokedReloadDataCount += 1
    }
}

