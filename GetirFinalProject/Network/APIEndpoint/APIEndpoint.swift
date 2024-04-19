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
        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/") else {
            fatalError("api base url is corrupted")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getVerticalListProducts:
            return "products"
        case .getHorizontalListProducts:
            return "suggestedProducts"
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
        nil
    }
}
