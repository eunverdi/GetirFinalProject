//
//  URL+Extension.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 22.04.2024.
//

import Foundation

extension URL {
    public static func string(_ urlString: String) -> URL {
        guard let url = URL(string: urlString) else {
            fatalError("Could not initialize \(URL.self) string named \(urlString).")
        }
        return url
    }
}
