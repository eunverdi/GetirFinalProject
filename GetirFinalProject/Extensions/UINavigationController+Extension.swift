//
//  UINavigationController+Extension.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 12.04.2024.
//

import UIKit

extension UINavigationController {
    func setupNavigatonBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
                
        self.navigationBar.tintColor = .white
        UIBarButtonItem.appearance().tintColor = .white
    }
    
}
