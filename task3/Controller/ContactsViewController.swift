//
//  ViewController.swift
//  task3
//
//  Created by Misha Volkov on 19.12.22.
//

import UIKit

final class ContactsViewController: UIViewController {

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self

    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    addSubviews()
    createConstraints()
  }

  private func addSubviews() {
    view.addSubview(tableView)
  }

  private func createConstraints() {
    var constraints = [NSLayoutConstraint]()
//    let space: CGFloat = 5.0

    constraints.append(tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor))
    constraints.append(tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
    constraints.append(tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor))
    constraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))

    NSLayoutConstraint.activate(constraints)
  }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    20
  }

  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier,
                                                 for: indexPath) as? ContactsTableViewCell
    else {
      return UITableViewCell()
    }

    contactCell.contact = Contacts()

    return contactCell
  }


}
