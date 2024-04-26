//
//  AppDIContainer.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/19/24.
//

import Foundation

/// The purpose of this container is to instantiate dependencies required for this child coordinators , and insert dependencies into child container.
final class AppContainer {

    lazy var localJSONObjectResource: LocalJSONResource = {
        let filename: String = GlobalConstants.globalJSONResourceFileName
        return LocalJSONResource(jsonObjectName: filename)
    }()
    
    func makeListBeneficiariesFeatureContainer() -> ListBeneficiariesContainer {
        let dependencies = ListBeneficiariesContainer.Dependencies(localJSONResource: localJSONObjectResource)
        return ListBeneficiariesContainer(dependencies: dependencies)
    }
}
