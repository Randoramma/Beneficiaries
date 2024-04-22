//
//  Address.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/19/24.
//

import Foundation

/*
 "beneficiaryAddress": {
   "firstLineMailing": "8515 E Orchard Rd",
   "scndLineMailing": null,
   "city": "Greenwood Village",
   "zipCode": "80111",
   "stateCode": "CO",
   "country": "US"
 }
 */

/// this is the Decodable Struct for a beneficiary address parsed from local JSON.
struct BeneficiaryAddress: Decodable {
    let firstLineMailing, city, zipCode, stateCode, country : String
    let scndLineMailing : String?
    
    func formattedAddress() -> String {
            var formattedAddress = "\(firstLineMailing)\n"
            
            if let secondLine = scndLineMailing {
                formattedAddress += "\(secondLine)\n"
            }
            
            formattedAddress += "\(city) \(stateCode)  \(zipCode)\n"
            formattedAddress += country
            
            return formattedAddress
        }
}
