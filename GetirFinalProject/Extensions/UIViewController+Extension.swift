//
//  UIViewController+Extension.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 22.04.2024.
//

import UIKit

public enum AlertActionType {
    case ok
    case cancel
}

extension UIViewController {
    func showDeletedProductAlert(title: String, message: String, completion: @escaping (AlertActionType) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Hayır", style: .destructive) { _ in
            completion(.cancel)
        }
        let cancel = UIAlertAction(title: "Evet", style: .default) { _ in
            completion(.ok)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
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
