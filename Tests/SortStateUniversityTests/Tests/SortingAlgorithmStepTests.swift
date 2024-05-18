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
        let input = DefaultSortingAlgorithmInputFactory().make(.worst, count: 10)
        var mergeSort = MergeSort<Int>(input: input)
        let step = mergeSort()
        
        XCTAssertNotNil(step.comparison)
        XCTAssertNil(step.output)
        
        XCTAssert(step.isComparison)
        XCTAssert(step.isNotFinished)
        
        XCTAssertFalse(step.isNotComparison)
        XCTAssertFalse(step.isFinished)
    }
    
    func test_finished() {
        let input = DefaultSortingAlgorithmInputFactory().make(.worst, count: 1)
        var mergeSort = MergeSort<Int>(input: input)
        let step = mergeSort()
        
        XCTAssertNotNil(step.output)
        XCTAssertNil(step.comparison)
        
        XCTAssert(step.isFinished)
        XCTAssert(step.isNotComparison)
        
        XCTAssertFalse(step.isNotFinished)
        XCTAssertFalse(step.isComparison)
    }
}

