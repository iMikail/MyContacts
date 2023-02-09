//
//  Contacts.swift
//  MyContacts
//
//  Created by Misha Volkov on 20.12.22.
//

import Foundation

final class Contact: Codable {
    static let defaultImage = "userIcon"

    var id: String
    var givenName: String
    var middleName: String
    var familyName: String
    var fullName: String { return "\(familyName) \(givenName) \(middleName)" }
    var phoneNumber: String?
    let imageData: Data?
    var isFavorite = false

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
