//
//  Observable.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import Foundation

final class Observable<T> {
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
