//
//  ComplexityTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 4/29/21.
//

import XCTest

@testable import SortStateUniversity

final class ComplexityTests: XCTestCase {
    // NO-OP
}

// MARK: - General Tests

extension ComplexityTests {
    // MARK: Tests
    
    func test_allCasesInOrder_noMissingCases() {
        XCTAssertEqual(Set(Complexity.allCases), Set(Complexity.allCasesInOrder))
    }
}

// MARK: - Comparable Tests

extension ComplexityTests {
    // MARK: Tests
    
    func test_lessThan() {
        XCTAssert(Complexity.constant < Complexity.logarithmic)
        XCTAssert(Complexity.logarithmic < Complexity.linear)
        XCTAssert(Complexity.linear < Complexity.linearithmic)
        XCTAssert(Complexity.linearithmic < Complexity.quadratic)
        XCTAssert(Complexity.quadratic < Complexity.exponential)
        XCTAssert(Complexity.exponential < Complexity.factorial)
    }
}
