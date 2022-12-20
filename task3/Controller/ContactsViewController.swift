//
//  ViewController.swift
//  task3
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit
import Contacts

final class ContactsViewController: UIViewController {
  private var contacts = [CNContact]()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self

    return tableView
  }()
  private lazy var loadContactsButton: UIButton = {
    let button = UIButton(configuration: .bordered())
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(NSLocalizedString(LocalizationKeys.titleLoadContactsButton.rawValue, comment: ""), for: .normal)
    button.addTarget(self, action: #selector(loadContacts), for: .touchUpInside)

    return button
  }()
  private lazy var deniedAccessView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .lightGray
    view.layer.borderColor = UIColor.darkGray.cgColor
    view.layer.borderWidth = 2.0
    view.layer.cornerRadius = 10.0

    return view
  }()
  private lazy var accessMessageLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18.0)
    label.text = NSLocalizedString(LocalizationKeys.accessMessageForDeniedStatus.rawValue, comment: "")

    return label
  }()
  private lazy var appOptionsButton: UIButton = {
    let button = UIButton(configuration: .gray())
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(NSLocalizedString(LocalizationKeys.titleAppOptionsButton.rawValue, comment: ""), for: .normal)
    let action = UIAction { _ in
      guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }

      if UIApplication.shared.canOpenURL(settingUrl) {
        UIApplication.shared.open(settingUrl)
      }
    }
    button.addAction(action, for: .touchUpInside)

    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    if CNContactStore.authorizationStatus(for: .contacts) == .denied {
      setupDeniedAccessView()
    }
    if contacts.isEmpty {
      setupLoadContactsButton()
    }
  }

  @objc private func loadContacts() {
    CNContactStore().requestAccess(for: .contacts) { [weak self](access, error) in
      guard let self = self else { return }
      guard access == true else {
        self.setupDeniedAccessView()
        return
      }

      let store = CNContactStore()
      let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
      ]
      let request = CNContactFetchRequest(keysToFetch: keysToFetch)
      do {
        try store.enumerateContacts(with: request) { (contact, stop) in
          self.contacts.append(contact)
        }
      } catch {
        print("unable to fetch contacts")
      }
      self.setupTableView()
    }
  }

  private func setupLoadContactsButton() {
    view.addSubview(loadContactsButton)

    NSLayoutConstraint.activate([
      loadContactsButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 150.0),
      loadContactsButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0),
      loadContactsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadContactsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  private func setupTableView() {
    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  private func setupDeniedAccessView() {
    deniedAccessView.addSubview(accessMessageLabel)
    deniedAccessView.addSubview(appOptionsButton)
    view.addSubview(deniedAccessView)

    NSLayoutConstraint.activate([
      deniedAccessView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
      deniedAccessView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
      deniedAccessView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      deniedAccessView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      accessMessageLabel.heightAnchor.constraint(equalTo: deniedAccessView.heightAnchor, multiplier: 0.6),
      accessMessageLabel.widthAnchor.constraint(equalTo: deniedAccessView.widthAnchor, multiplier: 0.8),
      accessMessageLabel.centerXAnchor.constraint(equalTo: deniedAccessView.centerXAnchor),
      accessMessageLabel.topAnchor.constraint(equalTo: deniedAccessView.topAnchor),
      appOptionsButton.heightAnchor.constraint(equalTo: deniedAccessView.heightAnchor, multiplier: 0.25),
      appOptionsButton.widthAnchor.constraint(equalTo: deniedAccessView.widthAnchor, multiplier: 0.75),
      appOptionsButton.centerXAnchor.constraint(equalTo: deniedAccessView.centerXAnchor),
      appOptionsButton.topAnchor.constraint(equalTo: accessMessageLabel.bottomAnchor)
    ])

  }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }

  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier,
                                                 for: indexPath) as? ContactsTableViewCell
    else {
      return UITableViewCell()
    }

    //contactCell.contact = Contacts()

    return contactCell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("seleceted")
  }

}
