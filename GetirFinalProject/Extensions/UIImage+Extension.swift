//
//  UIImage+Extension.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 22.04.2024.
//

import UIKit

extension UIImage {
    public static func named(_ name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            fatalError("Could not initialize \(UIImage.self) named \(name).")
        }
        return image
    }
    
    public static func systemName(_ systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName) else {
            fatalError("Could not initialize \(UIImage.self) systemName \(systemName).")
        }
        return image
    }
}
