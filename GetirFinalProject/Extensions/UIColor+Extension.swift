//
//  UIColor+Extension.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 22.04.2024.
//

import UIKit

extension UIColor {
    public static func named(_ name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("Could not initialize \(UIColor.self) named \(name).")
        }
        return color
    }
}
