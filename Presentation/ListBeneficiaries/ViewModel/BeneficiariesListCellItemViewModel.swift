//
//  BenefitsListItemViewModel.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/21/24.
//

import Foundation

/// ViewModel for Beneficiaries List Cell
struct BeneficiariesListCellItemViewModel {
    
    struct BeneficiaryItemViewModel {
        let lastName: String
        let firstName: String
        let beneType: String
        let designationCode: String
    }
    
    let model: BeneficiaryItemViewModel
}

extension BeneficiariesListCellItemViewModel {
    init(model: Beneficiary) {
        self.model = .init(lastName: model.lastName,
                           firstName: model.firstName,
                           beneType: model.beneType,
                           designationCode: model.designationCode.displayName())
    }
}
