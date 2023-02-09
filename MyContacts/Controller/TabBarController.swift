//
//  TabBarController.swift
//  MyContacts
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

        var color: UIColor {
            switch self {
            case .contacts:
                return ContactsViewController.mainColor
            case .favorites:
                return FavoritesContactsViewController.mainColor
            }
        }
    }

    private var animationImages: [UIImageView]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        animationImages = createAnimationImages()
    }

    private func setupTabBar() {
        let items = TabBarItem.allCases
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = items.first?.color

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
            let selectedImage = UIImage(systemName: item.selectedImageName)?
                .withTintColor(item.color, renderingMode: .alwaysOriginal)
            let tabBarItem = UITabBarItem(title: item.title,
                                          image: UIImage(systemName: item.imageName),
                                          selectedImage: selectedImage)
            tabBarItem.tag = index
            viewController.tabBarItem = tabBarItem
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.tintColor = TabBarItem(rawValue: item.tag)?.color

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
                imageView.image?.withTintColor(.red)
                imageView.contentMode = .center
                imageViews.append(imageView)
            }
        }

        return imageViews
    }
}
