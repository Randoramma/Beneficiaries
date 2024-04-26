//
//  BeneficiaryModalViewController.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/21/24.
//

import UIKit

final class BeneficiaryDetailModalViewController: UIViewController {
    
    private enum Constraints {
        static let verticalSpaceConstraint: CGFloat = 10
        static let leadingAnchorConstraint: CGFloat = 20
        static let trailingAnchorConstraint: CGFloat = -20
    }
    
    // - MARK: Label Constructors 
    private let stackView = UIStackView()
    private let lastNameLabel = UILabel()
    private let firstNameLabel = UILabel()
    private let beneTypeLabel = UILabel()
    private let designationCodeLabel = UILabel()
    private let ssnLabel = UILabel()
    private let dobLabel = UILabel()
    private let phoneNumberLabel = UILabel()
    private let addressLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    private var viewModel: BeneficiaryDetailModalViewModel
    
    // - MARK: Initializers 
    init(viewModel: BeneficiaryDetailModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupStackView()
        self.setupLabels()
        self.setupCloseButton()
    }
    
    // - MARK: UI Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupStackView() {
        self.stackView.axis = .vertical
        self.stackView.distribution = .equalSpacing
        self.stackView.alignment = .fill
        self.stackView.spacing = Constraints.verticalSpaceConstraint
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.stackView)

        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.leadingAnchorConstraint),
            self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraints.trailingAnchorConstraint),
            self.stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupLabels() {
        let labels = [lastNameLabel, firstNameLabel, beneTypeLabel, designationCodeLabel,
                      ssnLabel, dobLabel, phoneNumberLabel, addressLabel]
        labels.forEach {
            $0.numberOfLines = 0
            $0.font = .preferredFont(forTextStyle: .body)
            $0.textColor = .label
            self.stackView.addArrangedSubview($0)
        }
    }

    private func setupCloseButton() {
        self.closeButton.setTitle(GlobalConstants.closeButtonTitle, for: .normal)
        self.closeButton.tintColor = .label
        self.closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        self.stackView.addArrangedSubview(closeButton)
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    func configure() {
        self.lastNameLabel.text = "\(GlobalConstants.lastNameTitle): \(self.viewModel.model.lastName)"
        self.firstNameLabel.text = "\(GlobalConstants.firstNameTitle): \(self.viewModel.model.firstName)"
        self.beneTypeLabel.text = "\(GlobalConstants.beneficiaryTypeTitle): \(self.viewModel.model.beneType)"
        self.designationCodeLabel.text = "\(GlobalConstants.designationCodeTitle): \(self.viewModel.model.designationCode)"
        self.ssnLabel.text = "\(GlobalConstants.socialSecurityNumberTitle): \(self.viewModel.model.ssn)"
        self.dobLabel.text = "\(GlobalConstants.dateOfBirthTitle): \(self.viewModel.model.dob)"
        self.phoneNumberLabel.text = "\(GlobalConstants.phoneNumberTitle): \(self.viewModel.model.phoneNumber)"
        self.addressLabel.text = "\(GlobalConstants.addressTitle): \(self.viewModel.model.address)"
    }
}
