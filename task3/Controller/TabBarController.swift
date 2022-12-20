//
//  TabBarController.swift
//  task3
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit

final class TabBarController: UITabBarController {

  private enum TabBarItem: Int, CaseIterable {
    case contacts
    case favorites

    var title: String {
      switch self {
      case .contacts: return "Contacts list"
      case .favorites: return "Favorite contacts"
      }
    }
    var imageName: String {
      switch self {
      case .contacts: return "person.crop.circle"
      case .favorites: return "star"
      }
    }
    var selectedImageName: String {
      switch self {
      case .contacts: return "person.crop.circle.fill"
      case .favorites: return "star.fill"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.backgroundColor = .systemBackground
    setupTabBar()
  }

  private  func setupTabBar() {
    let items = TabBarItem.allCases

    viewControllers = items.map {
      switch $0 {
      case .contacts:
          let contactVC = ContactsViewController()

          return UINavigationController(rootViewController: contactVC)
      case .favorites:
         return FavoritesContactsViewController()
      }
    }

    viewControllers?.enumerated().forEach { (index, viewController) in
      let item = items[index]
      viewController.tabBarItem = UITabBarItem(title: item.title,
                                               image: UIImage(systemName: item.imageName),
                                               selectedImage: UIImage(systemName: item.selectedImageName))
    }
  }
}
