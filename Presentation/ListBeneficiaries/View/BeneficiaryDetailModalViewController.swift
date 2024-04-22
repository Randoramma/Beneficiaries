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
        setupView()
        setupStackView()
        setupLabels()
        setupCloseButton()
    }
    
    // - MARK: UI Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = Constraints.verticalSpaceConstraint
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.leadingAnchorConstraint),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraints.trailingAnchorConstraint),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupLabels() {
        let labels = [lastNameLabel, firstNameLabel, beneTypeLabel, designationCodeLabel,
                      ssnLabel, dobLabel, phoneNumberLabel, addressLabel]
        labels.forEach {
            $0.numberOfLines = 0
            $0.font = .preferredFont(forTextStyle: .body)
            $0.textColor = .label
            stackView.addArrangedSubview($0)
        }
    }

    private func setupCloseButton() {
        closeButton.setTitle(GlobalConstants.closeButtonTitle, for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        stackView.addArrangedSubview(closeButton)
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    func configure() {
        lastNameLabel.text = "\(GlobalConstants.lastNameTitle): \(self.viewModel.model.lastName)"
        firstNameLabel.text = "\(GlobalConstants.firstNameTitle): \(self.viewModel.model.firstName)"
        beneTypeLabel.text = "\(GlobalConstants.beneficiaryTypeTitle): \(self.viewModel.model.beneType)"
        designationCodeLabel.text = "\(GlobalConstants.designationCodeTitle): \(self.viewModel.model.designationCode)"
        ssnLabel.text = "\(GlobalConstants.socialSecurityNumberTitle): \(self.viewModel.model.ssn)"
        dobLabel.text = "\(GlobalConstants.dateOfBirthTitle): \(self.viewModel.model.dob)"
        phoneNumberLabel.text = "\(GlobalConstants.phoneNumberTitle): \(self.viewModel.model.phoneNumber)"
        addressLabel.text = "\(GlobalConstants.addressTitle): \(self.viewModel.model.address)"
    }
}
