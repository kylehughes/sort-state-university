//
//  ComplexityTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 4/29/21.
//

import XCTest

@testable import SortStateUniversity

final class ComplexityTests: XCTestCase {
    // MARK: Tests
    
    func test_allCasesInOrder_noMissingCases() {
        XCTAssertEqual(Set(Complexity.allCases), Set(Complexity.allCasesInOrder))
    }
}
