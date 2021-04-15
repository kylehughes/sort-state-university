//
//  SortingAlgorithmStepTests.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 5/1/21.
//

import Foundation
import XCTest

@testable import SortStateUniversity

final class SortingAlgorithmStepTests: XCTestCase {
    // NO-OP
}

// MARK: - Bespoke Interface Tests

extension SortingAlgorithmStepTests {
    // MARK: Tests
    
    func test_comparison() {
        var mergeSort = MergeSort<Int>.makeForTest(inputLength: 10, inputState: .shuffled)
        let step = mergeSort()
        
        XCTAssertNotNil(step.comparison)
        XCTAssertNil(step.output)
        
        XCTAssert(step.isComparison)
        XCTAssert(step.isNotFinished)
        
        XCTAssertFalse(step.isNotComparison)
        XCTAssertFalse(step.isFinished)
    }
    
    func test_finished() {
        var mergeSort = MergeSort<Int>.makeForTest(inputLength: 1, inputState: .shuffled)
        let step = mergeSort()
        
        XCTAssertNotNil(step.output)
        XCTAssertNil(step.comparison)
        
        XCTAssert(step.isFinished)
        XCTAssert(step.isNotComparison)
        
        XCTAssertFalse(step.isNotFinished)
        XCTAssertFalse(step.isComparison)
    }
}

