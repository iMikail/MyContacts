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
      case .contacts:
          return NSLocalizedString(AppLocalization.ContactListVC.tabBarItem.key, comment: "")
      case .favorites:
          return NSLocalizedString(AppLocalization.FavoritesContactsVC.tabBarItem.key, comment: "")
      }
    }
    var imageName: String {
      switch self {
      case .contacts:
          return "person.crop.circle"
      case .favorites:
          return "heart"
      }
    }
    var selectedImageName: String {
      switch self {
      case .contacts:
          return "person.crop.circle.fill"
      case .favorites:
          return "heart.fill"
      }
    }
  }

  private var animationImages: [UIImageView]?

  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.backgroundColor = .systemBackground
    setupTabBar()
    animationImages = createAnimationImages()
  }

  private func setupTabBar() {
    let items = TabBarItem.allCases

    viewControllers = items.map {
      switch $0 {
      case .contacts:
          let contactVC = ContactsViewController()
          contactVC.title = NSLocalizedString(AppLocalization.ContactListVC.tabBarItem.key, comment: "")

          return UINavigationController(rootViewController: contactVC)
      case .favorites:
         return FavoritesContactsViewController()
      }
    }

    viewControllers?.enumerated().forEach { (index, viewController) in
      let item = items[index]
      let tabBarItem = UITabBarItem(title: item.title,
                                    image: UIImage(systemName: item.imageName),
                                    selectedImage: UIImage(systemName: item.selectedImageName))
      tabBarItem.tag = index
      viewController.tabBarItem = tabBarItem
    }
  }

  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if let imageView = animationImages?[item.tag] {
      imageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
      UIView.animate(withDuration: 0.8,
                     delay: .zero,
                     usingSpringWithDamping: 0.7,
                     initialSpringVelocity: 0.5,
                     options: .curveLinear) {
        imageView.transform = .identity
      }
    }
  }

  private func createAnimationImages() -> [UIImageView] {
    var imageViews = [UIImageView]()

    for item in TabBarItem.allCases {
      if let imageView = tabBar.subviews[item.rawValue].subviews.first as? UIImageView {
        imageView.contentMode = .center
        imageViews.append(imageView)
      }
    }

    return imageViews
  }
}
