//
//  FetchListBeneficiariesUseCase.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/20/24.
//

import Foundation
import Combine


/// Protocol describing the work carried out by the use case.. in this case its fetching an array of Beneficiaries.
protocol FetchListBeneficiariesUsable {
    func fetch() -> AnyPublisher<[Beneficiary], Error>
}

/// the purpose of this class is to organize/ carryout business logic to obtain a list of beneficiaries from the JSON file.
///  - Note: Each new aspect of business logic should he added as a Use case to the ViewModel
final class FetchListBeneficiariesUseCase: FetchListBeneficiariesUsable {
    
    private let collectionOfBeneficiaries: JSONFileReadable
    
    init(collectionOfBeneficiaries: JSONFileReadable) {
        self.collectionOfBeneficiaries = collectionOfBeneficiaries
    }
    
    func fetch() -> AnyPublisher<[Beneficiary], Error> {
        collectionOfBeneficiaries.fetchBeneficiaries()
            .map { beneficiaries -> [Beneficiary] in
                return beneficiaries.sorted(by: { $0.lastName < $1.lastName })
            }
            .eraseToAnyPublisher()
    }
}
