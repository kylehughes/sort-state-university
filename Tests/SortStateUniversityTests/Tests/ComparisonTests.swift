//
//  ComparisonTests.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 5/8/21.
//

import XCTest

@testable import SortStateUniversity

final class ComparisonTests: XCTestCase {
    // NO-OP
}

// MARK: - Bespoke Interface Tests

extension ComparisonTests {
    // MARK: Tests
    
    func test_subscript() throws {
        var mergeSort = MergeSort(input: [1, 2, 3])
        let comparison = try XCTUnwrap(mergeSort().comparison)
        
        XCTAssertEqual(comparison[.left], comparison.left)
        XCTAssertEqual(comparison[.right], comparison.right)
    }
}
