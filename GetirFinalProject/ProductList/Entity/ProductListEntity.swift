//
//  ProductEntity.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import Foundation

struct HListProductsModel: Codable {
    let products: [Product]?
    let id, name: String
    
    struct Product: Codable {
        let id: String
        let imageURL: String?
        let price: Double
        let name, priceText: String
        let shortDescription, category: String?
        let unitPrice: Double?
        let squareThumbnailURL: String?
        let status: Int?
    }
}

struct VListProductModel: Codable {
    let id: String?
    let name: String?
    let productCount: Int?
    let products: [Product]?
    let email, password: String?
    
    struct Product: Codable {
        let id, name: String?
        let attribute: String?
        let thumbnailURL, imageURL: String?
        let price: Double?
        let priceText: String?
        let shortDescription: String?
    }
}

struct ProductPresentation {
    let id: String?
    let name: String?
    let attribute: String?
    let price: Double?
    let imageURL: String?
    var currentAmount: String?
}
