//
//  MergeSortTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 4/18/21.
//

import XCTest

@testable import SortStateUniversity

final class MergeSortTests: XCTestCase {
    let inputRange = 0 ... 100
    
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
        // Given…
        
        let input = makeInput(length: inputLength, state: inputState)
        let expectedOutput = input.sorted()
        
        // When…

        let mergeSort = MergeSort(input: input)
        let finishedMergeSort = perform(mergeSort)
        var mutableFinishedMergeSort = finishedMergeSort
        
        // Then…

        XCTAssertEqual(expectedOutput, finishedMergeSort.output)
        XCTAssertEqual(expectedOutput, mutableFinishedMergeSort().output)
    }
    
    private func testIdempotency(inputLength: Int, inputState: InputState) {
        // Given…
        
        let input = makeInput(length: inputLength, state: inputState)
        
        // When…
        
        let mergeSort = MergeSort(input: input)
        
        perform(mergeSort) { previousSort, comparison, currentSort in
            var nextSort = currentSort
            let _ = nextSort()
            
            var extraneousSort = nextSort
            let _ = extraneousSort()
            
            // Then…
            
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
    
    private func makeInput(length: Int, state: InputState) -> [Int] {
        guard 0 < length else {
            return []
        }
        
        var array: [Int] = []
        
        for i in 1 ... length {
            array.append(i)
        }
        
        switch state {
        case .bestCase:
            return array
        case .shuffled:
            return array.shuffled()
        case .worstCase:
            return array.reversed()
        }
    }
    
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

// MARK: - InputState Definition

private enum InputState: CaseIterable {
    case bestCase
    case shuffled
    case worstCase
}
