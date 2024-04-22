//
//  BenefitsListItemTableViewCell.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/21/24.
//

import UIKit

final class BenefitsListItemTableViewCell: UITableViewCell {
    
    private enum Constraints {
        static let verticalSpaceConstraint: CGFloat = 0
    }
    
    // - MARK: Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViewLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewLayout()
    }
    
    // - MARK: Label Constructors
    private let beneficiaryFirstNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let beneficiaryLastNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let beneficiaryTypeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let beneficiaryDesignationTypeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    // - MARK: View Setup
    private lazy var benefitsListMainVerticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            beneficiaryFirstNameLabel,
            beneficiaryLastNameLabel,
            beneficiaryTypeLabel,
            beneficiaryDesignationTypeLabel
        ])
        
        stack.axis = .vertical
        stack.spacing = Constraints.verticalSpaceConstraint
        return stack
    }()
    
    private func setupViewLayout() {
        contentView.addSubview(benefitsListMainVerticalStack)
        benefitsListMainVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            benefitsListMainVerticalStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            benefitsListMainVerticalStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            benefitsListMainVerticalStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            benefitsListMainVerticalStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func configure(_ model: BeneficiariesListCellItemViewModel) {
        beneficiaryLastNameLabel.text = model.model.lastName
        beneficiaryFirstNameLabel.text = model.model.firstName
        beneficiaryTypeLabel.text = "\(GlobalConstants.beneficiaryTypeTitle): \(model.model.beneType)"
        beneficiaryDesignationTypeLabel.text = "\(GlobalConstants.designationCodeTitle): \(model.model.designationCode)"
    }
    
    // - MARK: LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        beneficiaryDesignationTypeLabel.text = nil
        beneficiaryTypeLabel.text = nil
        beneficiaryFirstNameLabel.text = nil
        beneficiaryLastNameLabel.text = nil
    }
}

extension BenefitsListItemTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
