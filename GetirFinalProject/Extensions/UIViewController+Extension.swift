//
//  UIViewController+Extension.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 22.04.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
