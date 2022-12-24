//
//  Contacts.swift
//  task3
//
//  Created by Misha Volkov on 20.12.22.
//

import Foundation

final class Contact: Codable {
  static let defaultImage = "userIcon"

  internal var id: String
  internal var givenName: String
  internal var middleName: String
  internal var familyName: String
  internal var fullName: String { return "\(familyName) \(givenName) \(middleName)" }
  internal var phoneNumber: String?
  internal let imageData: Data?
  internal var isFavorite = false

  init(id: String, givenName: String, middleName: String, familyName: String,
       phoneNumber: String?, imageData: Data?) {
    self.id = id
    self.givenName = givenName
    self.middleName = middleName
    self.familyName = familyName
    self.phoneNumber = phoneNumber
    self.imageData = imageData
  }
}
