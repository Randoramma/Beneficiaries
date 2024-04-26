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
        self.setupViewLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViewLayout()
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
            self.beneficiaryFirstNameLabel,
            self.beneficiaryLastNameLabel,
            self.beneficiaryTypeLabel,
            self.beneficiaryDesignationTypeLabel
        ])
        
        stack.axis = .vertical
        stack.spacing = Constraints.verticalSpaceConstraint
        return stack
    }()
    
    private func setupViewLayout() {
        contentView.addSubview(self.benefitsListMainVerticalStack)
        self.benefitsListMainVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.benefitsListMainVerticalStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            self.benefitsListMainVerticalStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            self.benefitsListMainVerticalStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            self.benefitsListMainVerticalStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func configure(_ model: BeneficiariesListCellItemViewModel) {
        self.beneficiaryLastNameLabel.text = model.model.lastName
        self.beneficiaryFirstNameLabel.text = model.model.firstName
        self.beneficiaryTypeLabel.text = "\(GlobalConstants.beneficiaryTypeTitle): \(model.model.beneType)"
        self.beneficiaryDesignationTypeLabel.text = "\(GlobalConstants.designationCodeTitle): \(model.model.designationCode)"
    }
    
    // - MARK: LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        self.beneficiaryDesignationTypeLabel.text = nil
        self.beneficiaryTypeLabel.text = nil
        self.beneficiaryFirstNameLabel.text = nil
        self.beneficiaryLastNameLabel.text = nil
    }
}

extension BenefitsListItemTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
