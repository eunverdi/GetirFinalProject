//
//  SceneDelegate.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let productListVC = ProductListRouter.createModule()
        let navigatonVC = UINavigationController(rootViewController: productListVC)
        navigatonVC.setupNavigatonBar()
        window.makeKeyAndVisible()
        window.rootViewController = navigatonVC
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

