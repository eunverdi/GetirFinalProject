//
//  ProductListPresenterTest.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import XCTest
@testable import GetirFinalProject

final class ProductListPresenterTest: XCTestCase {
    var view: MockProductListViewController!
    var router: MockProductListRouter!
    var interactor: MockProductListInteractor!
    var sut: ProductListPresenter!
    
    var stubHListProductModel: HListProductsModel = .init(
        products: [
            .init(id: "1", imageURL: "imageURLString", price: 10.0, name: "Product 1", priceText: "$10", shortDescription: "This is product 1", category: "Category 1", unitPrice: 10.0, squareThumbnailURL: "https://example.com/thumb1.jpg", status: 1)
        ],
        id: "1",
        name: "HList 1"
    )

    var stubVListProductModel: VListProductModel = .init(
        id: "1",
        name: "VList 1",
        productCount: 1,
        products: [
            .init(id: "1", name: "Product 1", attribute: "Attribute 1", thumbnailURL: "https://example.com/thumb1.jpg", imageURL: "imageURLString", price: 10.0, priceText: "$10", shortDescription: "This is product 1")
        ],
        email: "example@example.com",
        password: "password"
    )
    
    override func setUp() {
        view = MockProductListViewController()
        router = MockProductListRouter()
        interactor = MockProductListInteractor()
        sut = ProductListPresenter(view: view, interactor: interactor, router: router)
    }
    
    override func tearDown() {
        view = nil
        router = nil
        interactor = nil
        sut = nil
    }
    
    func test_viewDidLoad_InvokeRequiredMethods() {
        XCTAssertFalse(view.invokedPrepareViewDidLoad)
        XCTAssertFalse(interactor.invokedFetchProducts)
        
        sut.viewDidLoad()
        
        XCTAssertTrue(view.invokedPrepareViewDidLoad)
        XCTAssertTrue(interactor.invokedFetchProducts)
    }
    
    func test_numberOfRowsInSection_WithFailedResult_ReturnCountAsZero() {
        XCTAssertEqual(sut.numberOfRowsInSectionVerticalListProducts(), .zero)
        XCTAssertEqual(sut.numberOfRowsInSectionHorizontalListProducts(), .zero)
        
        sut.fetchVerticalListProductsOutputs(.failure(NSError(domain: "error", code: -1)))
        sut.fetchHorizontalListProductsOutputs(.failure(NSError(domain: "error", code: -1)))
        
        XCTAssertEqual(sut.numberOfRowsInSectionVerticalListProducts(), .zero)
        XCTAssertEqual(sut.numberOfRowsInSectionHorizontalListProducts(), .zero)
    }
    
    func test_numberOfRowsInSection_WithSuccessResult_ReturnProductCount() {
        XCTAssertEqual(sut.numberOfRowsInSectionVerticalListProducts(), .zero)
        XCTAssertEqual(sut.numberOfRowsInSectionHorizontalListProducts(), .zero)
        
        sut.fetchVerticalListProductsOutputs(.success([stubVListProductModel]))
        sut.fetchHorizontalListProductsOutputs(.success([stubHListProductModel]))

        XCTAssertEqual(sut.numberOfRowsInSectionVerticalListProducts(), 1)
        XCTAssertEqual(sut.numberOfRowsInSectionHorizontalListProducts(), 1)
    }
    
    func test_getProductPresentation_AtIndexPathWithNotNilResponse() {
        sut.fetchVerticalListProductsOutputs(.success([stubVListProductModel]))
        sut.fetchHorizontalListProductsOutputs(.success([stubHListProductModel]))
        
        let hListPresentation = sut.getHListProductPresentation(at: .init(item: .zero, section: .zero))
        let vListPresentation = sut.getVListProductPresentation(at: .init(item: .zero, section: .zero))
        
        XCTAssertEqual(hListPresentation.id, "1")
        XCTAssertEqual(hListPresentation.imageURL, "imageURLString")
        XCTAssertEqual(hListPresentation.price, 10.0)
        XCTAssertEqual(hListPresentation.name, "Product 1")
        XCTAssertEqual(hListPresentation.attribute, " ")
        XCTAssertEqual(hListPresentation.currentAmount, "0")
        
        XCTAssertEqual(vListPresentation.id, "1")
        XCTAssertEqual(vListPresentation.name, "Product 1")
        XCTAssertEqual(vListPresentation.price, 10.0)
        XCTAssertEqual(vListPresentation.imageURL, "imageURLString")
        XCTAssertEqual(vListPresentation.attribute, "Attribute 1")
        XCTAssertEqual(vListPresentation.currentAmount, "0")
    }
    
    func test_goToProductDetail_WithIndexPath_InvokeRequiredMethods() {
        sut.fetchVerticalListProductsOutputs(.success([stubVListProductModel]))
        sut.fetchHorizontalListProductsOutputs(.success([stubHListProductModel]))
        
        XCTAssertEqual(router.invokedNavigateCount, .zero)
        
        sut.navigateToProductDetail(at: .init(item: .zero, section: .zero), section: .horizontalListProducts)
        
        XCTAssertEqual(router.invokedNavigateCount, 1)
        
        sut.navigateToProductDetail(at: .init(item: .zero, section: .zero), section: .verticalListProducts)
        
        XCTAssertEqual(router.invokedNavigateCount, 2)
    }
}
