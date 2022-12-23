//
//  Contacts.swift
//  task3
//
//  Created by Misha Volkov on 20.12.22.
//

import Foundation

final class Contact {
  static let defaultImage = "userIcon"

  private var givenName: String
  private var middleName: String
  private var familyName: String
  internal var fullName: String { return "\(familyName) \(givenName) \(middleName)" }
  internal var phoneNumber: String?
  internal let imageData: Data?
  internal var isFavorite = false

  init(givenName: String, middleName: String, familyName: String,
       phoneNumber: String?, imageData: Data?) {
    self.givenName = givenName
    self.middleName = middleName
    self.familyName = familyName
    self.phoneNumber = phoneNumber
    self.imageData = imageData
  }

  internal func updateNames(fromFullName fullName: String) {
    let names = fullName.split(separator: " ", maxSplits: 2).map { String($0) }

    switch names.count {
    case 0: setNames(givenName: "?", middleName: "", familyName: "")
    case 1: setNames(givenName: names[0], middleName: "", familyName: "")
    case 2: setNames(givenName: names[1], middleName: "", familyName: names[0])
    default: setNames(givenName: names[1], middleName: names[2], familyName: names[0])
    }
  }

  private func setNames(givenName: String, middleName: String, familyName: String) {
    self.givenName = givenName
    self.middleName = middleName
    self.familyName = familyName
  }

  internal func setFavorite() {
    isFavorite = !isFavorite
  }
}
