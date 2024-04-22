//
//  BeneficiaryDetailModalViewModel.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/21/24.
//

import Foundation


/// View Model for the Beneficiary Detail Modal 
struct BeneficiaryDetailModalViewModel {
    
    struct BeneficiaryDetailItemViewModel {
        let lastName: String
        let firstName: String
        let beneType: String
        let designationCode: String
        let ssn: String
        let dob: String
        let phoneNumber: String
        let address: String
    }
    
    let model: BeneficiaryDetailItemViewModel
}

extension BeneficiaryDetailModalViewModel {
    init(model: Beneficiary) {
        self.model = .init(lastName: model.lastName,
                           firstName: model.firstName,
                           beneType: model.beneType,
                           designationCode: model.designationCode.displayName(),
                           ssn: model.socialSecurityNumber,
                           dob: model.formatDateOfBirth(),
                           phoneNumber: model.phoneNumber,
                           address: model.beneficiaryAddress.formattedAddress())
    }
}
