//
//  SceneDelegate.swift
//  MyContacts
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarVC = TabBarController()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
}
