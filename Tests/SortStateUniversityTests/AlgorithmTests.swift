//
//  AlgorithmTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 5/1/21.
//

import Foundation
import XCTest

@testable import SortStateUniversity

final class AlgorithmTests: XCTestCase {
    // NO-OP
}

// MARK: - General Tests

extension AlgorithmTests {
    // MARK: Tests
    
    func test_numberOfComparisonsInWorstCase() {
        for i in 0 ... 100 {
            XCTAssertEqual(
                MergeSort<Int>.makeForTest(inputLength: i, inputState: .shuffled).numberOfComparisonsInWorstCase,
                MergeSort<Int>.calculateMaximumNumberOfComparisonsInWorstCase(for: i)
            )
        }
    }
}
