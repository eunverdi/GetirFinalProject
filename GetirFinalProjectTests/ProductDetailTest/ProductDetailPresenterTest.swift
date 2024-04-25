//
//  ProductDetailPresenterTest.swift
//  GetirFinalProjectTests
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import XCTest
@testable import GetirFinalProject

final class HomeDetailPresenterTests: XCTestCase {

    var view: MockHomeDetailViewController!
    var router: MockProductDetailRouter!
    var interactor: MockProductDetailInteractor!
    var sut: ProductDetailPresenter!
    
    private func createSut(with productPresentation: ProductPresentation) {
        sut = .init( view: view, interactor: interactor, router: router, presentation: productPresentation)
    }
    
    override func setUp() {
        view = MockHomeDetailViewController()
        router = MockProductDetailRouter()
        interactor = MockProductDetailInteractor()
        sut = ProductDetailPresenter(view: view, interactor: interactor, router: router, presentation: .init(id: "1", name: "Product 1", attribute: "Attribute 1", price: 10.0, imageURL: "imageURLString", currentAmount: "0"))
    }
    
    override func tearDown() {
        view = nil
        router = nil
        interactor = nil
        sut = nil
    }
    
    func test_viewDidLoad_InvokeRequiredMethods() {
        XCTAssertEqual(view.invokedConfigureSubviewsCount, .zero)
        XCTAssertEqual(view.invokedConfigureSuperviewCount, .zero)
        XCTAssertEqual(view.invokedConfigureNavigationBarCount, .zero)
        XCTAssertEqual(view.invokedSetDelegatesCount, .zero)
        
        sut.viewDidLoad(detailsView: ProductDetailsView())
        
        XCTAssertEqual(view.invokedConfigureSubviewsCount, 1)
        XCTAssertEqual(view.invokedConfigureSuperviewCount, 1)
        XCTAssertEqual(view.invokedConfigureNavigationBarCount, 1)
        XCTAssertEqual(view.invokedSetDelegatesCount, 1)
    }
}
