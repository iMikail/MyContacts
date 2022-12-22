//
//  Contacts.swift
//  task3
//
//  Created by Misha Volkov on 20.12.22.
//

import Contacts

final class Contacts {
  private let givenName: String
  private let middleName: String
  private let familyName: String
  internal var fullName: String?
  internal var phoneNumbers: String?
  internal let imageData: Data?
  internal var isFavorite = false

  init(contact: CNContact) {
    givenName = contact.givenName
    middleName = contact.middleName
    familyName = contact.familyName
    fullName = "\(familyName) \(givenName) \(middleName)"
    phoneNumbers = contact.phoneNumbers.first?.value.stringValue
    imageData = contact.imageData
  }

  internal func setFavorite() {
    isFavorite = !isFavorite
  }
}
