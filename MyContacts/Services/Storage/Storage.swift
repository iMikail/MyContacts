//
//  Storage.swift
//  MyContacts
//
//  Created by Misha Volkov on 24.12.22.
//

import Foundation

final class Storage {
    private init() {}

    static func save(_ object: [Contact]) {
        guard let url = Storage.getURL() else { return }

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(ContactsManager.shared.appContacts)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data)
        } catch {
            print(error.localizedDescription)
        }
    }

    static func retrieveContacts() -> [Contact] {
        var contacts = [Contact]()
        guard let url = Storage.getURL() else { return contacts }

        if !FileManager.default.fileExists(atPath: url.path) {
            print("File at path \(url.path) does not exist")
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                contacts = try decoder.decode([Contact].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }

        return contacts
    }

    private static func getURL() -> URL? {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appending(path: ContactsManager.fileName) {
            return url
        } else {
            print("Could not create URL")
            return nil
        }
    }

}
