//
//  BuiltInSortingAlgorithmTypeTests.swift
//  Sort State University
//
//  Created by Kyle Hughes on 6/22/24.
//

import Foundation
import SortStateUniversity
import XCTest

final class BuiltInSortingAlgorithmTypeTests: XCTestCase {}

// MARK: - Bespoke Interface Tests

extension BuiltInSortingAlgorithmTypeTests {
    // MARK: Tests
    
    func test_allCasesInAlphabeticalOrder() {
        XCTAssertEqual(
            BuiltInSortingAlgorithmType.allCases.sorted { $0.label.name < $1.label.name},
            BuiltInSortingAlgorithmType.allCasesInAlphabeticalOrder
        )
    }
}
