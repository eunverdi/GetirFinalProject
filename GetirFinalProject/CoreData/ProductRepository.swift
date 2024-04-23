//
//  CoreDataManager.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 16.04.2024.
//

import UIKit
import CoreData

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }

    var valueChanged: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }
}


protocol ProductRepositoryProtocol: AnyObject {
    func checkIsAddedToCart(with productID: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func getProductsFromPersistance(completion: @escaping (Result<[ProductInCart], Error>) -> Void)
    func createProduct(with presentation: ProductPresentation)
    func deleteProduct(with id: String)
}

final class ProductRepository: NSObject {
    static let shared = ProductRepository()
    private override init() {}
    var products = Observable<[ProductInCart]>([])
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var moc: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}

extension ProductRepository: ProductRepositoryProtocol {
    
    private func updateProductsObservable() {
            do {
                let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
                request.returnsObjectsAsFaults = false
                let products = try moc.fetch(request)
                self.products.value = products
            } catch {
                print("ProductRepository: Failed to fetch products: \(error)")
            }
        }
    
    func checkIsAddedToCart(with productID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = productIDPredicate(of: request, with: productID)
            let fetchedResults = try moc.fetch(request)
            fetchedResults.first != nil ? completion(.success(true)) : completion(.success(false))
        } catch {
            completion(.failure(error))
        }
    }
    
    func calculateTotalCost() {
        do {
            let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
            request.returnsObjectsAsFaults = false
            let products = try moc.fetch(request)
            let totalCost = products.reduce(0) { (result, product) -> Double in
                let productPrice = Double(product.price)
                let productAmount = Double(product.currentAmount ?? "0") ?? 0.0
                return result + (productPrice * productAmount)
            }
            NotificationCenter.default.post(name: Constants.NotificationName.totalCost,
                                            object: nil,
                                            userInfo: [Constants.NotificationUserInfo.totalCostUpdated: totalCost])
        } catch {
            print(error)
        }
    }

    func getProductCount(with productID: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = productIDPredicate(of: request, with: productID)
            let fetchedResults = try moc.fetch(request)
            if fetchedResults.first != nil {
                completion(.success(fetchedResults.first?.currentAmount ?? "0"))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getProductsFromPersistance(completion: @escaping (Result<[ProductInCart], Error>) -> Void) {
        do {
            let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
            request.returnsObjectsAsFaults = false
            let products = try moc.fetch(request)
            completion(.success(products))
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateProductAmount(with presentation: ProductPresentation) {
        let fetchRequest: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
        let id = presentation.id
        fetchRequest.predicate = NSPredicate(format: "id == %@", id!)
        
        do {
            let products = try moc.fetch(fetchRequest)
            if let productInCart = products.first {
                productInCart.currentAmount = presentation.currentAmount
                appDelegate.saveContext()
                calculateTotalCost()
                updateProductsObservable()
            } else {
                print("ProductRepository: Product not found")
            }
        } catch {
            print("ProductRepository: Failed to fetch product: \(error)")
        }
    }
    
    func createProduct(with presentation: ProductPresentation) {
        let productInCart = ProductInCart(context: moc)
        productInCart.id = presentation.id
        productInCart.name = presentation.name
        productInCart.price = presentation.price!
        productInCart.attribute = presentation.attribute
        productInCart.imageURL = presentation.imageURL
        productInCart.currentAmount = presentation.currentAmount
        
        appDelegate.saveContext()
        calculateTotalCost()
        updateProductsObservable()
    }
    
    func deleteProduct(with id: String) {
        let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = productIDPredicate(of: request, with: id)
        do {
            let fetchedResult = try moc.fetch(request)
            if let movieModel = fetchedResult.first {
                moc.delete(movieModel)
                appDelegate.saveContext()
                calculateTotalCost()
                updateProductsObservable()
            }
        } catch {
            print("ProductRepository: Error while deleting products\(error)")
        }
    }
}

extension ProductRepository {
    private func productIDPredicate(of request: NSFetchRequest<ProductInCart>, with id: String) -> NSPredicate {
        request.predicate = NSPredicate(format: "id == %@", id)
        return request.predicate!
    }
}
