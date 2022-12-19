//
//  SceneDelegate.swift
//  task3
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

    let contactsVC = ContactsViewController()
    let navigationVC = UINavigationController(rootViewController: contactsVC)
    let favoriteContactsVC = FavoriteContactsViewController()
    let tabBarVC = UITabBarController()
    tabBarVC.viewControllers = [navigationVC, favoriteContactsVC]

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = tabBarVC
    window?.makeKeyAndVisible()
  }
}
