//
//  CoreDataManager.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 16.04.2024.
//

import UIKit
import CoreData

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
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var moc: NSManagedObjectContext? {
        appDelegate?.persistentContainer.viewContext
    }
}

extension ProductRepository: ProductRepositoryProtocol {
    func checkIsAddedToCart(with productID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let moc = moc else {
            return
        }
        
        do {
            let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = productIDPredicate(of: request, with: productID)
            let fetchedResults = try moc.fetch(request)
            if fetchedResults.first != nil {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func calculateTotalCost() {
        guard let moc = moc else {
            return
        }
        
        do {
            let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
            request.returnsObjectsAsFaults = false
            let products = try moc.fetch(request)
            let totalCost = products.reduce(0) { result, product -> Double in
                let productPrice = Double(product.price)
                let productAmount = Double(product.currentAmount ?? "0") ?? 0.0
                return result + (productPrice * productAmount)
            }
            NotificationCenter.default.post(name: Constants.NotificationName.totalCost, object: nil, userInfo: [Constants.NotificationUserInfo.totalCostUpdated: totalCost])
        } catch {
            print(error)
        }
    }

    func getProductCount(with productID: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let moc = moc else {
            return
        }
        
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
        guard let moc = moc else {
            return
        }
        
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
        guard let moc = moc else {
            return
        }
        let fetchRequest: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
        guard let id = presentation.id else {
            return
        }
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let products = try moc.fetch(fetchRequest)
            if let productInCart = products.first {
                productInCart.currentAmount = presentation.currentAmount
                appDelegate?.saveContext()
                calculateTotalCost()
                updateProductsObservable()
                print("ProductRepository: Product amount succesfully updated.")
            } else {
                print("ProductRepository: Product not found")
            }
        } catch {
            print("ProductRepository: Failed to fetch product: \(error)")
        }
    }
    
    func createProduct(with presentation: ProductPresentation) {
        guard let moc = moc else {
            return
        }
        
        let productInCart = ProductInCart(context: moc)
        productInCart.id = presentation.id
        productInCart.name = presentation.name
        productInCart.price = presentation.price ?? 0.0
        productInCart.attribute = presentation.attribute
        productInCart.imageURL = presentation.imageURL
        productInCart.currentAmount = presentation.currentAmount
        
        print("ProductRepository: Product succesfully saved.")
        appDelegate?.saveContext()
        calculateTotalCost()
        updateProductsObservable()
    }
    
    func deleteProduct(with id: String) {
        guard let moc = moc else {
            return
        }
        
        let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = productIDPredicate(of: request, with: id)
        do {
            let fetchedResult = try moc.fetch(request)
            if let movieModel = fetchedResult.first {
                moc.delete(movieModel)
                appDelegate?.saveContext()
                calculateTotalCost()
                updateProductsObservable()
                print("ProductRepository: Product succesfully deleted.")
            }
        } catch {
            print("ProductRepository: Error while deleting products\(error)")
        }
    }
}

extension ProductRepository {
    private func updateProductsObservable() {
        guard let moc = moc else {
            return
        }
        
        do {
            let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
            request.returnsObjectsAsFaults = false
            let products = try moc.fetch(request)
            self.products.value = products
        } catch {
            print("ProductRepository: Failed to fetch products: \(error)")
        }
    }
}

extension ProductRepository {
    private func productIDPredicate(of request: NSFetchRequest<ProductInCart>, with id: String) -> NSPredicate? {
        request.predicate = NSPredicate(format: "id == %@", id)
        return request.predicate
    }
}
