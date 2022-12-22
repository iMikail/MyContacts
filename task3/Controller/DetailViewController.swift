//
//  DetailViewController.swift
//  task3
//
//  Created by Misha Volkov on 22.12.22.
//

import UIKit

final class DetailViewController: UIViewController {
  // MARK: - Variables
  internal var contact: Contacts?

  // MARK: - UIViews
  private lazy var fotoImageView: UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: ContactsTableViewCell.imageViewHeight * 2,
                                              height: ContactsTableViewCell.imageViewHeight * 2))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = imageView.frame.height / 2

    if let imageData = contact?.imageData {
      imageView.image = UIImage(data: imageData)
    }

    return imageView
  }()
  private lazy var fullNameLabel: UILabel = createTitleLabel(withTitle: "fullName")
  private lazy var fullNameTextField: UITextField = createTextField(withText: contact?.fullName ?? "")
  private lazy var fullNameStackView: UIStackView = createStackView(forViews: [fullNameLabel, fullNameTextField])

  private lazy var phoneLabel: UILabel = createTitleLabel(withTitle: "Phone number")
  private lazy var phoneTextField: UITextField = createTextField(withText: contact?.phoneNumbers ?? "")
  private lazy var phoneStackView: UIStackView = createStackView(forViews: [phoneLabel, phoneTextField])

  private lazy var infoStackView: UIStackView = {
    let spacing: CGFloat = 10.0
    let stackView = createStackView(forViews: [fullNameStackView, phoneStackView])
    stackView.spacing = spacing
    stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.backgroundColor = .lightGray
    stackView.layer.cornerRadius = 13.0
    stackView.layer.borderWidth = 2.0
    stackView.layer.borderColor = UIColor.darkGray.cgColor

    return stackView
  }()
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupViews()
  }

  private func setupViews() {
    view.addSubview(fotoImageView)
    view.addSubview(infoStackView)

    NSLayoutConstraint.activate([
      fotoImageView.heightAnchor.constraint(equalToConstant: fotoImageView.frame.height),
      fotoImageView.widthAnchor.constraint(equalToConstant: fotoImageView.frame.width),
      fotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      fotoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      infoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      infoStackView.topAnchor.constraint(equalTo: fotoImageView.bottomAnchor, constant: 10.0)
    ])
  }

  private func createTitleLabel(withTitle title: String) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 18.0)
    label.text = title

    return label
  }

  private func createTextField(withText text: String) -> UITextField {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.text = text
    textField.borderStyle = .roundedRect

    return textField
  }

  private func createStackView(forViews views: [UIView]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: views)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 2.0
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill

    return stackView
  }
}
