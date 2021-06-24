//
//  SortTestHarness.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 6/23/21.
//

import XCTest

@testable import SortStateUniversity

private let defaultInputLength = 100
private let rangeStart = 0
private let rangeEnd = 100

final class SortTestHarness<Sort> where Sort: SortingAlgorithm, Sort:Equatable, Sort.Element == Int {
    internal typealias ComparisonCompletion = (
        Sort?,
        Comparison<Sort>,
        Sort
    ) throws -> Void
    
    internal typealias SortFactory = (_ inputLength: Sort.Element, _ inputState: SortInputFactory.InputState) -> Sort
    
    private let inputRange: ClosedRange<Int>
    private let sortFactory: SortFactory
    
    // MARK: Internal Initialization
    
    init(sortFactory: @escaping SortFactory) {
        self.sortFactory = sortFactory
        
        inputRange = rangeStart ... rangeEnd
    }
    
    // MARK: Internal Static Interface
    
    @discardableResult
    internal static func perform(_ sort: Sort, comparisonCompletion: ComparisonCompletion? = nil) rethrows -> Sort {
        var sort = sort
        var previousSort: Sort? = nil
        
        while let comparison = sort().comparison {
            sort = comparison()
            try comparisonCompletion?(previousSort, comparison, sort)
            previousSort = sort
        }
        
        return sort
    }
    
    // MARK: Internal Instance Interface
    
    internal func makeSort(
        inputLength: Sort.Element = defaultInputLength,
        inputState: SortInputFactory.InputState
    ) -> Sort {
        sortFactory(inputLength, inputState)
    }
    
    @discardableResult
    internal func perform(
        inputLength: Sort.Element = defaultInputLength,
        inputState: SortInputFactory.InputState,
        comparisonCompletion: ComparisonCompletion? = nil
    ) rethrows -> Sort {
        try Self.perform(sortFactory(inputLength, inputState), comparisonCompletion: comparisonCompletion)
    }
    
    internal func testAlgorithm(inputState: SortInputFactory.InputState) {
        inputRange.forEach {
            testAlgorithm(inputLength: $0, inputState: inputState)
        }
    }
    
    internal func testAlgorithm(inputLength: Sort.Element, inputState: SortInputFactory.InputState) {
        let sort = sortFactory(inputLength, inputState)
        let expectedOutput = sort.input.sorted()
        
        let finishedSort = Self.perform(sort) { previousSort, comparison, currentSort in
            // The test uses the Comparable implementation for convenience so we want to double-check that the sort
            // will still be correct when the non-Comparable interface is used.
            if comparison.left < comparison.right {
                XCTAssertEqual(comparison(.left), currentSort)
            } else {
                XCTAssertEqual(comparison(.right), currentSort)
            }
        }
        
        var mutableFinishedSort = finishedSort

        XCTAssertEqual(finishedSort.output, expectedOutput)
        XCTAssertEqual(mutableFinishedSort().output, expectedOutput)
    }
    
    internal func testAnswerWhileFinished() {
        let finishedSort = perform(inputLength: defaultInputLength, inputState: .shuffled)
        
        var mutatedFinishedSort = finishedSort
        mutatedFinishedSort.answer(.left)
        mutatedFinishedSort.answer(.right)
        
        XCTAssertEqual(finishedSort, mutatedFinishedSort)
    }
    
    internal func testCalculateMaximumNumberOfComparisonsInWorstCase(with answers: [Sort.Element: Int]) {
        inputRange.forEach {
            XCTAssertEqual(Sort.calculateMaximumNumberOfComparisonsInWorstCase(for: $0), answers[$0])
        }
    }
    
    internal func testComplexity(expected: Complexity) {
        XCTAssertEqual(Sort.complexity, expected)
    }
    
    internal func testIdempotency(inputState: SortInputFactory.InputState) {
        inputRange.forEach {
            testIdempotency(inputLength: $0, inputState: inputState)
        }
    }
    
    internal func testIdempotency(inputLength: Sort.Element, inputState: SortInputFactory.InputState) {
        let sort = sortFactory(inputLength, inputState)
        
        Self.perform(sort) { previousSort, comparison, currentSort in
            var nextSort = currentSort
            let _ = nextSort()
            
            var extraneousSort = nextSort
            let _ = extraneousSort()
            
            XCTAssertNotEqual(currentSort, previousSort)
            XCTAssertEqual(extraneousSort, nextSort)
        }
    }
    
    internal func testLabel(expected: SortingAlgorithmLabel) {
        XCTAssertEqual(expected, Sort.label)
    }
    
    internal func testPeekAtElement() {
        let sort = sortFactory(defaultInputLength, .bestCase)
        
        XCTAssertEqual(1, sort.peekAtElement(for: .left))
        XCTAssertEqual(2, sort.peekAtElement(for: .right))
    }
    
    internal func testPeekAtElementWhileFinished() {
        let finishedSort = perform(inputLength: defaultInputLength, inputState: .shuffled)
        
        XCTAssertNil(finishedSort.peekAtElement(for: .left))
        XCTAssertNil(finishedSort.peekAtElement(for: .right))
    }
}
