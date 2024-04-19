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
    func deleteProduct(with id: String, completion: @escaping (Error) -> Void)
}

final class ProductRepository {
    static let shared = ProductRepository()
    private init() {}
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var moc: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}

extension ProductRepository: ProductRepositoryProtocol {
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
    
    func createProduct(with presentation: ProductPresentation) {
        let productInCart = ProductInCart(context: moc)
        productInCart.id = presentation.id
        productInCart.name = presentation.name
        productInCart.price = presentation.price
        productInCart.attribute = presentation.attribute
        productInCart.imageURL = presentation.imageURL
        productInCart.currentAmount = presentation.currentAmount
        
        appDelegate.saveContext()
    }
    
    func deleteProduct(with id: String, completion: @escaping (Error) -> Void) {
        let request: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = productIDPredicate(of: request, with: id)
        do {
            let fetchedResult = try moc.fetch(request)
            if let movieModel = fetchedResult.first {
                moc.delete(movieModel)
                appDelegate.saveContext()
            }
        } catch {
            completion(error)
        }
    }
}

extension ProductRepository {
    private func productIDPredicate(of request: NSFetchRequest<ProductInCart>, with id: String) -> NSPredicate {
        request.predicate = NSPredicate(format: "id == %@", id)
        return request.predicate!
    }
}
