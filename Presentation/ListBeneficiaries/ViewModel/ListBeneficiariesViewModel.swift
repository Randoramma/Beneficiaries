//
//  ListBeneficiariesViewModel.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/20/24.
//

import Foundation
import Combine

protocol ListBeneficiariesViewModelInput {
    func viewDidLoad()
}

protocol ListBeneficiariesViewModelOutput {
    var content: ListBeneficiariesViewModelState { get } 
    var error: String? { get }
}

protocol ListBeneficiariesViewable:
    ListBeneficiariesViewModelInput,
    ListBeneficiariesViewModelOutput,
    ObservableObject {}

enum ListBeneficiariesViewModelState {
    case items([Beneficiary])
    case empty
    case loading
}

final class ListBeneficiariesViewModel: ListBeneficiariesViewable {

    @Published private (set) var content: ListBeneficiariesViewModelState = .empty
    @Published var error: String?
    
    private (set) var items: [Beneficiary] = []
    private var cancellables: Set<AnyCancellable> = []
    private let listBeneficiariesUseCase: FetchListBeneficiariesUsable
    
    init(listBeneficiariesUseCase: FetchListBeneficiariesUsable) {
        self.listBeneficiariesUseCase = listBeneficiariesUseCase
    }

    private func reload() {
        resetData()
        loadData()
    }
    
    private func resetData() {
        items.removeAll()
        content = .empty
    }
    
    /// This is loading the data from the use case into the view model seperating the presentation layer from the data layer.
    /// - Note: the finished block is not being used because fetch handles the response via map.  Can be expanded later. 
    private func loadData() {
        content = .loading
        listBeneficiariesUseCase.fetch()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    // Currently handled in the receiveValue block.
                    break 
                case .failure(let error):
                    self.error = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] beneficiaries in
                guard let self = self else { return }
                self.update(beneficiaries)
                print("Recieved Values \(beneficiaries.count)")
                // Perhaps set content to .loaded or update the UI accordingly
            })
            .store(in: &self.cancellables)
    }
    
    private func update(_ beneficiaries: [Beneficiary]) {
        items = beneficiaries
        updateContent()
    }
    
    private func updateContent() {
        content = items.isEmpty ? .empty : .items(items)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

extension ListBeneficiariesViewModel: ListBeneficiariesViewModelInput {
    func viewDidLoad() {
        reload()
    }
}
