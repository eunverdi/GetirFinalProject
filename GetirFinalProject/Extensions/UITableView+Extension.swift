//
//  UITableView+Extension.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 22.04.2024.
//

import UIKit

extension UITableView {
    public func register<T: UITableViewCell>(_ cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
