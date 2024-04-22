//
//  MainAppCoordinator.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/19/24.
//

import UIKit

/// The purpose of this coordinator is to route a user to a given container / coordinator flow based..
///  - This Coordinator kicks off the application 
final class MainAppCoordinator {
    var navigationController: UINavigationController
    private let appContainer: AppContainer
    
    init(navigationController: UINavigationController, appContainer: AppContainer) {
        self.navigationController = navigationController
        self.appContainer = appContainer
    }
    
    func start() {
        let listBeneficiariesFeatureContainer = appContainer.makeListBeneficiariesFeatureContainer()
        let flow = listBeneficiariesFeatureContainer.makeListBeneficiariesCooridnator(navigationController: navigationController)
        flow.start()
    }
}
