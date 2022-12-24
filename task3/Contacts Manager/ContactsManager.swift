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
  static let fileName = "Contacts"

// MARK: - Variables
  internal var appContacts: [Contact] {
    didSet {
      Storage.save(appContacts)
    }
  }
  internal var favoriteContacts: [Contact] {
    return appContacts.filter { $0.isFavorite == true }
  }
  internal var loadedHandler: ((Bool) -> Void) = { _ in }

// MARK: - Functions
  private init() {
    appContacts = Storage.retrieveContacts()
  }

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
            let appContact = self.createContact(fromCNContact: deviceContact)
            self.appContacts.append(appContact)
            self.loadedHandler(true)
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
  }

  private func createContact(fromCNContact contact: CNContact) -> Contact {
    let phonenumber = contact.phoneNumbers.first?.value.stringValue
    let imageData = (contact.imageData == nil) ? UIImage(named: Contact.defaultImage)?.pngData() : contact.imageData
    let appContact = Contact(id: contact.identifier, givenName: contact.givenName, middleName: contact.middleName,
                             familyName: contact.familyName, phoneNumber: phonenumber, imageData: imageData)
    if let number = phonenumber {
      setPhoneFormat(forContact: appContact, fromNumber: number)
    }
    return appContact
  }

  internal func removeContact(_ contact: Contact) {
    if let index = appContacts.firstIndex(where: { $0.id == contact.id }) {
      appContacts.remove(at: index)
    }
  }

  // MARK: Setting contact info
  internal func setFavorite(forContact contact: Contact) {
    contact.isFavorite = !contact.isFavorite
    Storage.save(appContacts)
  }

  internal func setNames(forContact contact: Contact, fromFullName fullName: String) {
    let names = fullName.split(separator: " ", maxSplits: 2).map { String($0) }

    switch names.count {
    case 0: updateNames(forContact: contact, givenName: ":]", middleName: "", familyName: "")
    case 1: updateNames(forContact: contact, givenName: names[0], middleName: "", familyName: "")
    case 2: updateNames(forContact: contact, givenName: names[1], middleName: "", familyName: names[0])
    default: updateNames(forContact: contact, givenName: names[1], middleName: names[2], familyName: names[0])
    }
  }

  private func updateNames(forContact contact: Contact, givenName: String, middleName: String, familyName: String) {
    contact.givenName = givenName
    contact.middleName = middleName
    contact.familyName = familyName
    Storage.save(appContacts)
  }

  internal func setPhoneFormat(forContact contact: Contact, fromNumber number: String) {
    let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    var result = ""
    if let mask = maskFormat(forNumber: cleanPhoneNumber) {
      var index = cleanPhoneNumber.startIndex

      for char in mask where index < cleanPhoneNumber.endIndex {
        if char == "X" {
          result.append(cleanPhoneNumber[index])
          index = cleanPhoneNumber.index(after: index)
        } else if char == "D" {
          index = cleanPhoneNumber.index(after: index)
        } else {
          result.append(char)
        }
      }
      contact.phoneNumber = result
    } else {
      contact.phoneNumber = number
    }
    Storage.save(appContacts)
  }

  private func maskFormat(forNumber number: String) -> String? {
    switch number.count {
    case 10:
      if let firstDigit = number.first, let index = Int("10\(firstDigit)") {
        return PhoneMask(rawValue: index)?.mask
      } else {
        return nil
      }
    default: return PhoneMask(rawValue: number.count)?.mask
    }
  }

  private enum PhoneMask: Int {
    case fiveNumbers = 5
    case sevenNumbers = 7
    case nineNumbers = 9
    case tenNumbersWithFirst0 = 100
    case tenNumbersWithFirst8 = 108
    case elevenNumbers = 11
    case twelveNumbers = 12

    var mask: String {
      switch self {
      case .fiveNumbers: return "X-XX-XX"
      case .sevenNumbers: return "XXX-XX-XX"
      case .nineNumbers: return "+375 (XX) XXX XX XX"
      case .tenNumbersWithFirst0: return "+375 (DXX) XXX XX XX"
      case .tenNumbersWithFirst8: return "X0XX-XXX-XX-XX"
      case .elevenNumbers: return "XXXX-XXX-XX-XX"
      case .twelveNumbers: return "+XXX (XX) XXX XX XX"
      }
    }
  }
}
