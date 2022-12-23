//
//  ContactsManager.swift
//  task3
//
//  Created by Misha Volkov on 21.12.22.
//

import UIKit
import Contacts

final class ContactsManager {
  static let shared = ContactsManager()

// MARK: - Variables
  internal var appContacts = [Contact]()
  internal var favoriteContacts: [Contact] {
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
            let appContact = self.createContact(from: deviceContact)
            self.appContacts.append(appContact)
            self.loadedHandler(true)
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
  }

  private func createContact(from contact: CNContact) -> Contact {
    let phone = contact.phoneNumbers.first?.value.stringValue
    let imageData = contact.imageData == nil ? UIImage(named: Contact.defaultImage)?.pngData() : contact.imageData

    return Contact(id: contact.identifier, givenName: contact.givenName, middleName: contact.middleName,
                   familyName: contact.familyName, phoneNumber: phone, imageData: imageData)
  }

  internal func removeContact(_ contact: Contact) {
    if let index = appContacts.firstIndex(where: { $0.id == contact.id }) {
      appContacts.remove(at: index)
    }

  }

}
