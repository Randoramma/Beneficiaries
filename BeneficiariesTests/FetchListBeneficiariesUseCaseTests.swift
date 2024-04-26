//
//  FetchListBeneficiariesUseCaseTests.swift
//  BeneficiariesTests
//
//  Created by Randy McLain on 4/26/24.
//

import XCTest
import Combine
@testable import Beneficiaries

final class FetchListBeneficiariesUseCaseTests: XCTestCase {

    private var sut:FetchListBeneficiariesUsable?
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        let jsonFile = LocalJSONResource(jsonObjectName: "Beneficiaries")
        sut = FetchListBeneficiariesUseCase(collectionOfBeneficiaries: jsonFile)
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
    }

    func testFetchListBeneficiariesUseCase_IsNotNil() throws {
        XCTAssertNotNil(sut)
    }
    
    func testFetchListBeneficiariesUseCase_Returned5Beneficiaries() throws {
        if let results = sut?.fetch() {
            results
                .sink(receiveCompletion: { _ in
                }, receiveValue: { beneficiaries in
                    XCTAssertEqual(beneficiaries.count, 5)
                })
                .store(in: &self.cancellables)
        } else {
            XCTFail("Results should not be nil")
        }
    }

    func testPerformanceLoadingBuildBeneficiaries() throws {
        let jsonfile = mockLocalJSONResource()
        sut = FetchListBeneficiariesUseCase(collectionOfBeneficiaries: jsonfile)
            self.measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()], block: {
            let expectation = XCTestExpectation(description: "Fetch beneficiaries")

                       sut?.fetch()
                           .sink(receiveCompletion: { _ in },
                                 receiveValue: { beneficiaries in
                                   XCTAssertEqual(beneficiaries.count, 1000)
                                   expectation.fulfill()
                           })
                           .store(in: &cancellables)

                       wait(for: [expectation], timeout: 5.0)
        })
    }
}


final class mockLocalJSONResource: JSONFileReadable {
    func fetchBeneficiaries() -> AnyPublisher<[Beneficiaries.Beneficiary], any Error> {
        Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                var beneficiaries: [Beneficiary] = []
                let _ = (1...1000).map { i in
                    let address = BeneficiaryAddress(firstLineMailing: "\(i)", city: "\(i)", zipCode: "\(i)", stateCode: "\(i)", country: "\(i)", scndLineMailing: "\(i)")
                    
                    let testelement = Beneficiary(lastName:"LastName\(i)", firstName: "FirstName\(i)", beneType: "C", socialSecurityNumber: "XXXX", dateOfBirth: "12345678", middleName: "R", phoneNumber: "123", beneficiaryAddress: address, designationCode: DesignationCode.init(rawValue: "C")!)
                    beneficiaries.append(testelement)
                }
                promise(.success(beneficiaries))
            }
        }.eraseToAnyPublisher()
    }
}
