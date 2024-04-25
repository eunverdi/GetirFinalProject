//
//  APIEndpoint.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import Foundation
import Moya

enum APIEndpoint {
    case getHorizontalListProducts
    case getVerticalListProducts
}

extension APIEndpoint: TargetType {
    var baseURL: URL {
        let url = URL.string(Constants.Network.baseURL)
        return url
    }
    
    var path: String {
        switch self {
        case .getVerticalListProducts:
            return Constants.Network.productsEndpoint
        
        case .getHorizontalListProducts:
            return Constants.Network.suggestedProductsEndpoint
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVerticalListProducts, .getHorizontalListProducts:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getVerticalListProducts, .getHorizontalListProducts:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        [:]
    }
}
