//
//  FavoriteContactsViewController.swift
//  task3
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit

final class FavoritesContactsViewController: UIViewController {
  private let contactsManager = ContactsManager.shared

  // MARK: - UIViews
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self

    return tableView
  }()

  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
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
extension FavoritesContactsViewController: UITableViewDelegate, UITableViewDataSource {
  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactsManager.favoriteContacts.count
  }

  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier,
                                                 for: indexPath) as? ContactsTableViewCell
    else {
      return UITableViewCell()
    }

    contactCell.contact = contactsManager.favoriteContacts[indexPath.row]
    contactCell.isUserInteractionEnabled = false

    return contactCell
  }

  internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }

}
