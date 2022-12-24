//
//  LocalizationKeys.swift
//  task3
//
//  Created by Misha Volkov on 20.12.22.
//

enum AppLocalization {

  enum ContactListVC: String {
    case title = "titleContactsVC"
    case tabBarItem = "titleTabBarItemContactsList"
    case loadContactsButton = "titleLoadContactsButton"

    var key: String { return self.rawValue }
  }

  enum DeniedAccessAlert: String {
    case message = "accessMessageForDeniedStatus"
    case button = "titleAppOptionsButton"

    var key: String { return self.rawValue }
  }

  enum DetailAlert: String {
    case copyPhone = "titleCopyPhoneAlertAction"
    case sharePhone = "titleSharePhoneAlertAction"
    case deleteContact = "titleDeleteContactAlertAction"
    case cancel

    var key: String { return self.rawValue }
  }

  enum DetailVC: String {
    case editButton = "titleEditContactTabBarButton"
    case saveButton = "titleSaveContactTabBarButton"
    case phoneNumber
    case fullName

    var key: String { return self.rawValue }
  }

  enum FavoritesContactsVC: String {
    case tabBarItem = "titleTabBarItemFavoritesContacts"

    var key: String { return self.rawValue }
  }
}
