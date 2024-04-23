//
//  Constants.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 12.04.2024.
//

import UIKit

public enum Constants {
    public enum Colors {
        public static let appMainColor = "appMainColor"
        public static let productImageBorderColor = "productImageBorderColor"
        public static let sectionHeaderColor = "sectionHeaderColor"
    }
    
    public enum NavigationItem {
        public static let productListTitle = "Ürünler"
        public static let productDetailTitle = "Ürün Detayı"
        public static let cartListTitle = "Sepetim"
    }
    
    public enum Fonts {
        public static let openSansSemibold = "OpenSans-SemiBold"
        public static let openSansBold = "OpenSans-Bold"
    }
    
    public enum ImageName {
        public static let xmark = "xmark"
        public static let trashButtonIcon = "trashButtonIcon"
        public static let plusButtonIcon = "plusButtonIcon"
        public static let minusButtonIcon = "minusButtonIcon"
        public static let cartButtonIcon = "cartButtonIcon"
    }
    
    public enum ButtonTitle {
        public static let addToCartButtonTitle = "Sepete Ekle"
        public static let completeOrder = "Siparişi Tamamla"
    }
    
    public enum NotificationName {
        public static let totalCost = NSNotification.Name("TotalCostUpdated")
    }
    
    public enum NotificationUserInfo {
        public static let totalCostUpdated = "totalCost"
    }
    
    public enum Network {
        public static let baseURL = "https://65c38b5339055e7482c12050.mockapi.io/api/"
        public static let productsEndpoint = "products"
        public static let suggestedProductsEndpoint = "suggestedProducts"
    }
    
    public enum CartList {
        public static let heightForRow = 120.0
    }
}
