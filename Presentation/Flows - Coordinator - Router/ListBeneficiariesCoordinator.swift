//
//  ListBeneficiariesCooridnator.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/20/24.
//

import UIKit

protocol ListBeneficiariesCoordinatorDependencies {
     func makeListBeneficiariesViewController() -> ListBeneficiariesViewController
}

/// Coordinator to route the logic flow to the presenter layer (ViewModel and View Controller) with dependencies for the List of Beneficiaries.
final class ListBeneficiariesCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ListBeneficiariesCoordinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: ListBeneficiariesCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeListBeneficiariesViewController()
        navigationController?.pushViewController(viewController, animated: false)
    }
}
