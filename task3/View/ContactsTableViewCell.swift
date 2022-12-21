//
//  ContactsTableViewCell.swift
//  task3
//
//  Created by Misha Volkov on 20.12.22.
//

import UIKit

final class ContactsTableViewCell: UITableViewCell {
  // MARK: - Variables
  static let identifier = "contactsTableCell"
  static let imageViewHeight: CGFloat = 50.0

  internal var contact: Contacts? {
    didSet {
      setupCell()
    }
  }

  // MARK: - UIViews
  private lazy var fotoImageView: UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: ContactsTableViewCell.imageViewHeight,
                                              height: ContactsTableViewCell.imageViewHeight))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = imageView.frame.height / 2

    return imageView
  }()
  private lazy var fullNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 18.0)
    label.textAlignment = .left

    return label
  }()
  private lazy var phoneNumberLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 17.0)
    label.textAlignment = .left

    return label
  }()
  private lazy var favoritesButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.configuration = UIButton.Configuration.plain()

    return button
  }()

  // MARK: - Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubviews()
    configurationFavoritesButton()
    createConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Functions
  private func setupCell() {
    guard let contact = contact else { return }

    if let imageData = contact.imageData {
      fotoImageView.image = UIImage(data: imageData)
    } else {
      fotoImageView.image = UIImage(systemName: "photo.circle")
    }
    fullNameLabel.text = contact.fullName
    phoneNumberLabel.text = contact.phoneNumbers
    updateFavoritesButtonImage()
  }

  private func configurationFavoritesButton() {
    let action = UIAction { [weak self] _ in
      guard let self = self else { return }

      self.contact?.setFavorite()
      self.updateFavoritesButtonImage()
    }
    favoritesButton.addAction(action, for: .touchUpInside)
  }

  private func updateFavoritesButtonImage() {
    guard let contact = contact else { return }
    let imageName = contact.isFavorite ? "heart.fill" : "heart"
    favoritesButton.configuration?.image = UIImage(systemName: imageName)
  }

  private func addSubviews() {
    contentView.addSubview(fotoImageView)
    contentView.addSubview(fullNameLabel)
    contentView.addSubview(phoneNumberLabel)
    contentView.addSubview(favoritesButton)
  }

  private func createConstraints() {
    var constraints = [NSLayoutConstraint]()
    let space: CGFloat = 5.0

    constraints.append(fotoImageView.heightAnchor.constraint(equalToConstant: fotoImageView.frame.height))
    constraints.append(fotoImageView.widthAnchor.constraint(equalToConstant: fotoImageView.frame.height))
    constraints.append(fotoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
    constraints.append(fotoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: space))

    constraints.append(fullNameLabel.leftAnchor.constraint(equalTo: fotoImageView.rightAnchor, constant: space))
    constraints.append(fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space))
    constraints.append(fullNameLabel.rightAnchor.constraint(equalTo: favoritesButton.leftAnchor, constant: -space))
    constraints.append(fullNameLabel.bottomAnchor.constraint(equalTo: fotoImageView.centerYAnchor))

    constraints.append(phoneNumberLabel.leftAnchor.constraint(equalTo: fullNameLabel.leftAnchor))
    constraints.append(phoneNumberLabel.topAnchor.constraint(equalTo: fotoImageView.centerYAnchor))
    constraints.append(phoneNumberLabel.rightAnchor.constraint(equalTo: fullNameLabel.rightAnchor))
    constraints.append(phoneNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -space))

    constraints.append(favoritesButton.heightAnchor.constraint(equalTo: fotoImageView.heightAnchor))
    constraints.append(favoritesButton.widthAnchor.constraint(equalTo: fotoImageView.widthAnchor))
    constraints.append(favoritesButton.centerYAnchor.constraint(equalTo: fotoImageView.centerYAnchor))
    constraints.append(favoritesButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -space))

    NSLayoutConstraint.activate(constraints)
  }
}
