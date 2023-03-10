//
//  DetailViewController.swift
//  MyContacts
//
//  Created by Misha Volkov on 22.12.22.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Variables
    var contact = Contact(id: "", givenName: "", middleName: "", familyName: "",
                          phoneNumber: "", imageData: nil)
    private var textFields = [UITextField]()
    override var isEditing: Bool {
        didSet {
            updateButtonTitle()
            updateTextFields()
        }
    }

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

        if let imageData = contact.imageData {
            imageView.image = UIImage(data: imageData)
        }

        return imageView
    }()

    private lazy var editButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }

            if self.isEditing {
                self.setContactInfo()
            }
            self.isEditing = !self.isEditing
        }
        let button = UIBarButtonItem(primaryAction: action)

        return button
    }()

    private lazy var fullNameLabel: UILabel = createTitleLabel(
        withTitle: NSLocalizedString(AppLocalization.DetailVC.fullName.key, comment: "")
    )

    private lazy var phoneLabel: UILabel = createTitleLabel(
        withTitle: NSLocalizedString(AppLocalization.DetailVC.phoneNumber.key, comment: "")
    )

    private lazy var fullNameTextField: UITextField = createTextField(withText: contact.fullName)
    private lazy var phoneTextField: UITextField = {
        let textField = createTextField(withText: contact.phoneNumber ?? "")
        textField.keyboardType = .numberPad

        return textField
    }()

    private lazy var fullNameStackView: UIStackView = createStackView(forViews: [fullNameLabel, fullNameTextField])
    private lazy var phoneStackView: UIStackView = createStackView(forViews: [phoneLabel, phoneTextField])

    private lazy var infoStackView: UIStackView = {
        let spacing: CGFloat = 10.0
        let stackView = createStackView(forViews: [fullNameStackView, phoneStackView])
        stackView.spacing = spacing
        stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 13.0
        stackView.layer.borderWidth = 2.0
        stackView.layer.borderColor = ContactsViewController.mainColor.cgColor

        return stackView
    }()

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFields.forEach { $0.resignFirstResponder() }
    }

    // MARK: Update views info
    private func updateTextFields() {
        textFields.forEach {
            $0.isUserInteractionEnabled = isEditing
            $0.borderStyle = isEditing ? .roundedRect : .none
        }
        fullNameTextField.text = contact.fullName
        phoneTextField.text = contact.phoneNumber
    }

    private func updateButtonTitle() {
        if isEditing {
            editButton.title = NSLocalizedString(AppLocalization.DetailVC.saveButton.key, comment: "")
            editButton.tintColor = .systemRed
        } else {
            editButton.title = NSLocalizedString(AppLocalization.DetailVC.editButton.key, comment: "")
            editButton.tintColor = ContactsViewController.mainColor
        }
    }

    // MARK: Update contact info
    private func setContactInfo() {
        if let fullName = fullNameTextField.text, let number = phoneTextField.text {
            ContactsManager.shared.setNames(forContact: contact, fromFullName: fullName)
            ContactsManager.shared.setPhoneFormat(forContact: contact, fromNumber: number)
        }
    }

    // MARK: Create Views
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
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = false
        textFields.append(textField)

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

    // MARK: Setup Views
    private func setupEditButton() {
        navigationItem.rightBarButtonItem = editButton
        updateButtonTitle()
    }

    private func setupViews() {
        setupEditButton()
        view.addSubview(fotoImageView)
        view.addSubview(infoStackView)

        let centerYConstraint = fotoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            fotoImageView.heightAnchor.constraint(equalToConstant: fotoImageView.frame.height),
            fotoImageView.widthAnchor.constraint(equalToConstant: fotoImageView.frame.width),
            fotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fotoImageView.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor),
            infoStackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5),
            infoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoStackView.topAnchor.constraint(equalTo: fotoImageView.bottomAnchor, constant: 10.0)
        ])
    }
}
