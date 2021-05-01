//
//  MergeSortTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 4/18/21.
//

import XCTest

@testable import SortStateUniversity

final class MergeSortTests: XCTestCase {
    private let inputRange = 0 ... 100
}

// MARK: - General Tests

extension MergeSortTests {
    // MARK: Tests
    
    func test_algorithm_bestCase() {
        inputRange.forEach {
            testAlgorithm(inputLength: $0, inputState: .bestCase)
        }
    }
    
    func test_algorithm_shuffled() {
        inputRange.forEach {
            testAlgorithm(inputLength: $0, inputState: .shuffled)
        }
    }
    
    func test_algorithm_worstCase() {
        inputRange.forEach {
            testAlgorithm(inputLength: $0, inputState: .worstCase)
        }
    }
    
    func test_idempotency_bestCase() {
        inputRange.forEach {
            testIdempotency(inputLength: $0, inputState: .bestCase)
        }
    }
    
    func test_idempotency_shuffled() {
        inputRange.forEach {
            testIdempotency(inputLength: $0, inputState: .shuffled)
        }
    }
    
    func test_idempotency_worstCase() {
        inputRange.forEach {
            testIdempotency(inputLength: $0, inputState: .worstCase)
        }
    }
    
    // MARK: Private Tests
    
    private func testAlgorithm(inputLength: Int, inputState: InputState) {
        let mergeSort = MergeSort<Int>.makeForTest(inputLength: inputLength, inputState: inputState)
        let expectedOutput = mergeSort.input.sorted()
        let finishedMergeSort = perform(mergeSort)
        var mutableFinishedMergeSort = finishedMergeSort

        XCTAssertEqual(expectedOutput, finishedMergeSort.output)
        XCTAssertEqual(expectedOutput, mutableFinishedMergeSort().output)
    }
    
    private func testIdempotency(inputLength: Int, inputState: InputState) {
        let mergeSort = MergeSort<Int>.makeForTest(inputLength: inputLength, inputState: inputState)
        
        perform(mergeSort) { previousSort, comparison, currentSort in
            var nextSort = currentSort
            let _ = nextSort()
            
            var extraneousSort = nextSort
            let _ = extraneousSort()
            
            XCTAssertNotEqual(previousSort, currentSort)
            XCTAssertEqual(nextSort, extraneousSort)
        }
    }
    
    // MARK: Private Helpers
    
    private typealias ComparisonCompletion<Element> = (
        MergeSort<Element>?,
        Comparison<MergeSort<Element>>,
        MergeSort<Element>
    ) -> Void
    where
        Element: Comparable

    @discardableResult
    private func perform<Element>(
        _ mergeSort: MergeSort<Element>,
        comparisonCompletion: ComparisonCompletion<Element>? = nil
    ) -> MergeSort<Element>
    where
        Element: Comparable
    {
        var mergeSort = mergeSort
        var previousMergeSort: MergeSort<Element>? = nil
        
        while let comparison = mergeSort().comparison {
            mergeSort = comparison()
            comparisonCompletion?(previousMergeSort, comparison, mergeSort)
            previousMergeSort = mergeSort
        }
        
        return mergeSort
    }
}
