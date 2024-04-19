//
//  NetworkManager.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import Foundation
import Moya

protocol APINetworkable {
    func getHorizontalListProducts(completion: @escaping (Result<[HListProductsModel], Error>) -> Void)
    func getVerticalListProducts(completion: @escaping (Result<[VListProductModel], Error>) -> Void)
}

final class NetworkManager: APINetworkable {

    private var provider: MoyaProvider<APIEndpoint> = MoyaProvider<APIEndpoint>()
    public init() {}
    
    public func getVerticalListProducts(completion: @escaping (Result<[VListProductModel], Error>) -> Void) {
        request(target: .getVerticalListProducts, completion: completion)
    }
    
    public func getHorizontalListProducts(completion: @escaping (Result<[HListProductsModel], Error>) -> Void) {
        request(target: .getHorizontalListProducts, completion: completion)
    }
}

extension NetworkManager {
    private func request<T: Decodable>(target: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
