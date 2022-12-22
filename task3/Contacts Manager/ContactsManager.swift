//
//  ContactsManager.swift
//  task3
//
//  Created by Misha Volkov on 21.12.22.
//

import Contacts

final class ContactsManager {
  static let shared = ContactsManager()

// MARK: - Variables
  internal var appContacts = [Contacts]()
  internal var favoriteContacts: [Contacts] {
    return appContacts.filter { $0.isFavorite == true }
  }
  internal var loadedHandler: ((Bool) -> Void) = { _ in }

// MARK: - Functions
  private init() {}

  internal func authorizationStatus() -> Bool {
    switch CNContactStore.authorizationStatus(for: .contacts) {
    case .authorized: return true
    case .notDetermined: return true
    default: return false
    }
  }

  internal func requestAccess() {
    CNContactStore().requestAccess(for: .contacts) { [weak self](access, error) in
      guard let self = self else { return }
      guard access == true else {
        DispatchQueue.main.async {
          self.loadedHandler(access)
        }
        return
      }

      if let error = error {
        print(error.localizedDescription)
      } else {
        self.loadContacts()
      }
    }
  }

  private func loadContacts() {
    DispatchQueue.global(qos: .background).async {
      let store = CNContactStore()
      let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey as CNKeyDescriptor,
        CNContactImageDataKey as CNKeyDescriptor
      ]
      let request = CNContactFetchRequest(keysToFetch: keysToFetch)

      do {
        try store.enumerateContacts(with: request) { [weak self](deviceContact, _) in
          guard let self = self else { return }

          DispatchQueue.main.async {
            let appContact = Contacts(contact: deviceContact)
            self.appContacts.append(appContact)
            self.loadedHandler(true)
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
  }

  internal func removeContact(at index: Int) {
    appContacts.remove(at: index)
  }

}
