//
//  ViewController.swift
//  task3
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit
import Contacts

final class ContactsViewController: UIViewController {
  // MARK: - Variables
  private var contacts = [CNContact]() {
    didSet {
      if contacts.isEmpty {
        tableView.isHidden = true
        loadContactsButton.isHidden = false
      } else {
        tableView.isHidden = false
        loadContactsButton.isHidden = true
      }
    }
  }

  // MARK: - UIViews
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.isHidden = true

    return tableView
  }()
  private lazy var loadContactsButton: UIButton = {
    let button = UIButton(configuration: .bordered())
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(NSLocalizedString(LocalizationKeys.titleLoadContactsButton.rawValue, comment: ""), for: .normal)
    button.addTarget(self, action: #selector(requestAccess), for: .touchUpInside)

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

  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupTableView()

    if CNContactStore.authorizationStatus(for: .contacts) == .denied {
      setupDeniedAccessView()
    }
    if contacts.isEmpty {
      setupLoadContactsButton()
    }
  }

  @objc private func requestAccess() {
    CNContactStore().requestAccess(for: .contacts) { [weak self](access, error) in
      guard let self = self else { return }
      guard access == true else {
        self.setupDeniedAccessView()
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
        try store.enumerateContacts(with: request) { [weak self](contact, _) in
          guard let self = self else { return }

          DispatchQueue.main.async {
            self.contacts.append(contact)
            self.tableView.reloadData()  // !! сделать в конце
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
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

// MARK: - Extension
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

    contactCell.contact = Contacts(contact: contacts[indexPath.row])

    return contactCell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("seleceted")
  }

}
