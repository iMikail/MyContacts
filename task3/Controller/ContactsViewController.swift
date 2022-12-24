//
//  ViewController.swift
//  task3
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit

final class ContactsViewController: UIViewController {
  // MARK: - Variables
  private let contactsManager = ContactsManager.shared
  private var isLoaded = false {
    didSet {
      tableView.reloadData()
      tableView.isHidden = !isLoaded
      loadContactsButton.isHidden = isLoaded
    }
  }

  // MARK: - UIViews
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
    let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                           action: #selector(longPress(longPressGestureRecognizer:)))
    tableView.addGestureRecognizer(longPressRecognizer)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.isHidden = true

    return tableView
  }()
  private lazy var loadContactsButton: UIButton = {
    let button = UIButton(configuration: .bordered())
    button.translatesAutoresizingMaskIntoConstraints = false
    let title = NSLocalizedString(AppLocalization.ContactListVC.loadContactsButton.key, comment: "")
    button.setTitle(title, for: .normal)
    button.addTarget(self, action: #selector(requestAccess), for: .touchUpInside)
    button.isHidden = true

    return button
  }()

  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupTableView()
    setupLoadContactsButton()

    if contactsManager.appContacts.isEmpty {
      loadContactsButton.isHidden = false
    } else {
      isLoaded = true
    }

    if !contactsManager.authorizationStatus() {
      showDeniedAccessMessage()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  @objc private func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: tableView)
      if let indexPath = tableView.indexPathForRow(at: touchPoint) {
        showDetailAlert(forContact: contactsManager.appContacts[indexPath.row])
      }
    }
  }

  @objc private func requestAccess() {
    contactsManager.loadedHandler = { [weak self] access in
      guard let self = self else { return }

      access ? self.isLoaded = access : self.showDeniedAccessMessage()
    }
    contactsManager.requestAccess()
  }

  // MARK: AlertControllers
  private func showDetailAlert(forContact contact: Contact) {
    let alertController = UIAlertController(title: contact.givenName,
                                            message: "", preferredStyle: .alert)
    let copyTitle = NSLocalizedString(AppLocalization.DetailAlert.copyPhone.key, comment: "")
    let copyPhoneAction = UIAlertAction(title: copyTitle, style: .default) { _ in
      UIPasteboard.general.string = contact.phoneNumber
    }

    let shareTitle = NSLocalizedString(AppLocalization.DetailAlert.sharePhone.key, comment: "")
    let sharePhoneAction = UIAlertAction(title: shareTitle, style: .default) { [weak self] _ in
      var text = contact.fullName
      if let phone = contact.phoneNumber {
        text += "\n" + phone
      }
      let activityController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
      self?.present(activityController, animated: true)
    }

    let deleteTitle = NSLocalizedString(AppLocalization.DetailAlert.deleteContact.key, comment: "")
    let deleteContactAction = UIAlertAction(title: deleteTitle, style: .destructive) { [weak self] _ in
      guard let self = self else { return }

      self.contactsManager.removeContact(contact)
      self.contactsManager.appContacts.isEmpty ? self.isLoaded = false : self.tableView.reloadData()
    }

    let cancelTitle = NSLocalizedString(AppLocalization.DetailAlert.cancel.key, comment: "")
    let canselAction = UIAlertAction(title: cancelTitle, style: .cancel)

    alertController.addAction(copyPhoneAction)
    alertController.addAction(sharePhoneAction)
    alertController.addAction(deleteContactAction)
    alertController.addAction(canselAction)

    present(alertController, animated: true)
  }

  private func showDeniedAccessMessage() {
    let titleController = NSLocalizedString(AppLocalization.DeniedAccessAlert.message.key, comment: "")
    let alertController = UIAlertController(title: titleController, message: nil, preferredStyle: .alert)
    let titleButton = NSLocalizedString(AppLocalization.DeniedAccessAlert.button.key, comment: "")
    let optionAction = UIAlertAction(title: titleButton, style: .default) { _ in
      guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }

      if UIApplication.shared.canOpenURL(settingUrl) {
        UIApplication.shared.open(settingUrl)
      }
    }

    alertController.addAction(optionAction)
    present(alertController, animated: true)
  }

  // MARK: Setup views
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
}

// MARK: - Extension
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactsManager.appContacts.count
  }

  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier,
                                                          for: indexPath) as? ContactsTableViewCell
    else {
      return UITableViewCell()
    }

    contactCell.contact = contactsManager.appContacts[indexPath.row]

    return contactCell
  }

  internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailVC = DetailViewController()
    detailVC.contact = contactsManager.appContacts[indexPath.row]
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
