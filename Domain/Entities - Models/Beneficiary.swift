//
//  Beneficiary.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/19/24.
//

import Foundation

/*
 "lastName": "Smith",
 "firstName": "John",
 "designationCode": "P",
 "beneType": "Spouse",
 "socialSecurityNumber": "XXXXX3333",
 "dateOfBirth": "04201979",
 "middleName": "D",
 "phoneNumber": "3035555555",
 "beneficiaryAddress": {
   "firstLineMailing": "8515 E Orchard Rd",
   "scndLineMailing": null,
   "city": "Greenwood Village",
   "zipCode": "80111",
   "stateCode": "CO",
   "country": "US"
 */

/// this is the Decodable Struct for a beneficiary object parsed from local JSON.
struct Beneficiary: Decodable {
    private struct Constants {
        static let monthsDigitCount: Int = 2
        static let dayDigitCount: Int = 2
        static let yearDigitCount: Int = 4
        static let dateOfBirthTotalDigitCount: Int = 8
    }
    let lastName, firstName, beneType, socialSecurityNumber, dateOfBirth, middleName, phoneNumber: String
    let beneficiaryAddress: BeneficiaryAddress
    let designationCode: DesignationCode
    
    func formatDateOfBirth() -> String {
        precondition(dateOfBirth.count == Constants.dateOfBirthTotalDigitCount, "Input must be exactly 8 characters long.")
        
        let month = dateOfBirth.prefix(Constants.monthsDigitCount)
        let day = dateOfBirth[dateOfBirth.index(dateOfBirth.startIndex,
                                                       offsetBy: Constants.dayDigitCount)..<dateOfBirth.index(dateOfBirth.startIndex,
                                                                                                              offsetBy: Constants.yearDigitCount)]
        let year = dateOfBirth.suffix(Constants.yearDigitCount)
        return "\(month)/\(day)/\(year)"
    }
}

enum DesignationCode: String, Decodable {
    case primary = "P"
    case contingent = "C"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        switch value {
        case "P":
            self = .primary
        case "C":
            self = .contingent
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unexpected designationCode value")
        }
    }
    
    func displayName() -> String {
        switch self {
        case .primary:
            return GlobalConstants.primaryBeneficiaryLabel
        case .contingent:
            return GlobalConstants.contingentBeneficiaryLabel
        }
    }
}
