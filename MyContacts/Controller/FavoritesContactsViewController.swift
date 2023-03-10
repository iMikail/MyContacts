//
//  FavoriteContactsViewController.swift
//  MyContacts
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit

final class FavoritesContactsViewController: UIViewController {
    static let mainColor = UIColor.systemPurple

    private let contactsManager = ContactsManager.shared

    // MARK: - UIViews
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = FavoritesContactsViewController.mainColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsManager.favoriteContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}
