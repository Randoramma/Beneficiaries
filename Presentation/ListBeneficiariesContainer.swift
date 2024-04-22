//
//  ListBeneficiariesContainer.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/20/24.
//

import UIKit


/// Object containing Dependencies (Model/ Entities), Use Cases (Business Logic), Presentation Layer (VC + VM) pertaining to the List Of Beneficiaries
/// - To be instantiated by the parent container and called by the parent coordinator
final class ListBeneficiariesContainer: ListBeneficiariesCoordinatorDependencies {
    
    // MARK: - dependencies
    struct Dependencies {
        // this will retrieve the Entities / Model object 
        let localJSONResource: LocalJSONResource
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - use cases / business logic
    func fetchListBeneficiariesUseCase() -> FetchListBeneficiariesUsable {
        FetchListBeneficiariesUseCase(collectionOfBeneficiaries: dependencies.localJSONResource)
    }
    
    // MARK: - UI
    func makeListBeneficiariesViewController() -> ListBeneficiariesViewController {
        let vc = ListBeneficiariesViewController(viewModel: makeListBeneficiariesViewModel())
        return vc
    }
    
    func makeListBeneficiariesViewModel() -> ListBeneficiariesViewModel {
        ListBeneficiariesViewModel(listBeneficiariesUseCase: fetchListBeneficiariesUseCase())
    }
    
    func makeListBeneficiariesCooridnator(navigationController: UINavigationController) -> ListBeneficiariesCoordinator {
        ListBeneficiariesCoordinator(navigationController: navigationController, dependencies: self)
    }
}
