//
//  LocalizationKeys.swift
//  task3
//
//  Created by Misha Volkov on 20.12.22.
//

enum LocalizationKeys {

  enum ContactListVC: String {
    case title = "titleContactsVC"
    case tabBarItem = "titleTabBarItemContactsList"
    case loadContactsButton = "titleLoadContactsButton"
  }

  enum DeniedAccessAlert: String {
    case message = "accessMessageForDeniedStatus"
    case button = "titleAppOptionsButton"
  }

  enum DetailAlert: String {
    case copyPhone = "titleCopyPhoneAlertAction"
    case sharePhone = "titleSharePhoneAlertAction"
    case deleteContact = "titleDeleteContactAlertAction"
    case cancel
  }

  enum DetailVC: String {
    case editButton = "titleEditContactTabBarButton"
    case saveButton = "titleSaveContactTabBarButton"
    case phoneNumber
    case fullName
  }

  enum FavoritesContactsVC: String {
    case tabBarItem = "titleTabBarItemFavoritesContacts"
  }
}
