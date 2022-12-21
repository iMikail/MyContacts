//
//  Contacts.swift
//  task3
//
//  Created by Misha Volkov on 20.12.22.
//

import Contacts

final class Contacts {
  private var givenName: String
  private var middleName: String
  private var familyName: String
  internal var fullName: String {
    return "\(familyName) \(givenName) \(middleName)"
  }
  internal var phoneNumbers: String?
  internal var imageData: Data?
  internal var isFavorite = false

  init(contact: CNContact) {
    givenName = contact.givenName
    middleName = contact.middleName
    familyName = contact.familyName
    phoneNumbers = contact.phoneNumbers.first?.value.stringValue
    imageData = contact.imageData
  }
}
