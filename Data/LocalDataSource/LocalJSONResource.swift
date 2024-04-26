//
//  LocalJSONResource.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/19/24.
//

import Foundation
import Combine

/// Protocol for objects reading Beneficiary from local file
/// - Requires Combine Framework
///  - Note: Should be Generic type to allow for varying object arrays to be read.
protocol JSONFileReadable {
    func fetchBeneficiaries() -> AnyPublisher<[Beneficiary], Error>
}

/// this class is responsible for fetching and parsing the beneficiaries from JSON.
final class LocalJSONResource: JSONFileReadable {
    
    let jsonObjectName: String
    init(jsonObjectName: String) {
        self.jsonObjectName = jsonObjectName
    }
    
    func fetchBeneficiaries() -> AnyPublisher<[Beneficiary], Error> {
       Future { promise in
           DispatchQueue.global(qos: .userInitiated).async {
               do {
                   
                   let url = Bundle.main.url(forResource: self.jsonObjectName,
                                             withExtension: GlobalConstants.jsonFileExtension)!
                   let data = try Data(contentsOf: url)
                   let beneficiaries = try JSONDecoder().decode([Beneficiary].self,
                                                                from: data)
                   promise(.success(beneficiaries))
               } catch {
                   promise(.failure(error))
               }
           }
       }
       .eraseToAnyPublisher()
   }
}

struct CustomError: Error {
    let originalError: Error
    let errorType: String
}
