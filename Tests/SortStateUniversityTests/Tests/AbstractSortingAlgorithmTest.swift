//
//  AbstractSortingAlgorithmTests.swift
//  Sort State University
//
//  Created by Kyle Hughes on 5/1/21.
//

import Foundation
import SortStateUniversity
import XCTest

public let defaultSortingAlgorithmTestInputCount = 100

public class AbstractSortingAlgorithmTests<Target>: XCTestCase 
where
    Target: Equatable & SortingAlgorithm,
    Target.Element == Int
{
    // MARK: Public Typealiases
    
    public typealias ComparisonCompletion = (
        Target?,
        Comparison<Target>,
        Target
    ) throws -> Void
    
    // MARK: Public Abstract Interface
    
    public var expectedComplexity: Complexity {
        fatalError("Must be implemented by subclass.")
    }
    
    public var expectedLabel: SortingAlgorithmLabel {
        fatalError("Must be implemented by subclass.")
    }
    
    public var expectedAverageNumberOfComparisons: [Int: Int] {
        fatalError("Must be implemented by subclass.")
    }
    
    public var expectedMaximumNumberOfComparisons: [Int: Int] {
        fatalError("Must be implemented by subclass.")
    }
    
    public var expectedMinimumNumberOfComparisons: [Int: Int] {
        fatalError("Must be implemented by subclass.")
    }
    
    public var inputFactory: any SortingAlgorithmInputFactory {
        fatalError("Must be implemented by subclass.")
    }
    
    public func target(for input: [Target.Element]) -> Target {
        fatalError("Must be implemented by subclass.")
    }
    
    // MARK: Public Class Interface
    
    @inlinable
    public class var isAbstractTestCase: Bool {
        self == AbstractSortingAlgorithmTests.self
    }
    
    // MARK: XCTestCase Implementation
    
    override class public var defaultTestSuite: XCTestSuite {
        guard isAbstractTestCase else {
            return super.defaultTestSuite
        }

        return XCTestSuite(name: "Empty Suite for \(Self.self)")
    }
    
    // MARK: Algorithm Idempotency Tests
    
    @inlinable
    public func test_algorithm_idempotency_bestCase() {
        helpTestAlgorithIdempotency(inputCase: .best, inputCount: defaultSortingAlgorithmTestInputCount)
    }
    
    @inlinable
    public func test_algorithm_idempotency_worstCase() {
        helpTestAlgorithIdempotency(inputCase: .worst, inputCount: defaultSortingAlgorithmTestInputCount)
    }

    // MARK: Algorithm Stability Tests

    @inlinable
    public func test_algorithm_stability_bestCase() {
        helpTestAlgorithmStability(inputCase: .best, inputCount: defaultSortingAlgorithmTestInputCount)
    }
    
    @inlinable
    public func test_algorithm_stability_worstCase() {
        helpTestAlgorithmStability(inputCase: .worst, inputCount: defaultSortingAlgorithmTestInputCount)
    }
    
    // MARK: Protocol Tests
    
    @inlinable
    public func test_protocol_answerWhileFinished_bestCase() {
        helpTestProtocolAnswerWhileFinished(inputCase: .best, inputCount: defaultSortingAlgorithmTestInputCount)
    }
    
    @inlinable
    public func test_protocol_answerWhileFinished_worstCase() {
        helpTestProtocolAnswerWhileFinished(inputCase: .worst, inputCount: defaultSortingAlgorithmTestInputCount)
    }
    
    @inlinable
    public func test_protocol_averageNumberOfComparisons() {
        var actualOutput: [Int: Int] = [:]
        var succeeded: Bool = true
        
        for (inputCount, expectedNumberOfComparisons) in expectedAverageNumberOfComparisons {
            let actualNumberOfComparisons = Target.averageNumberOfComparisons(for: inputCount)
            actualOutput[inputCount] = actualNumberOfComparisons
            succeeded = succeeded && actualNumberOfComparisons == expectedNumberOfComparisons
            XCTAssertEqual(actualNumberOfComparisons, expectedNumberOfComparisons)
        }
        
        if !succeeded {
            print("<\(Target.self)> Actual Average Number of Comparisons:")
            printToLookLikeCode(actualOutput)
        }
    }
    
    @inlinable
    public func test_protocol_maximumNumberOfComparisons() {
        var actualOutput: [Int: Int] = [:]
        var succeeded: Bool = true
        
        for (inputCount, expectedNumberOfComparisons) in expectedMaximumNumberOfComparisons {
            let actualNumberOfComparisons = Target.maximumNumberOfComparisons(for: inputCount)
            actualOutput[inputCount] = actualNumberOfComparisons
            succeeded = succeeded && actualNumberOfComparisons == expectedNumberOfComparisons
            XCTAssertEqual(actualNumberOfComparisons, expectedNumberOfComparisons)
        }
        
        if !succeeded {
            print("<\(Target.self)> Actual Maximum Number of Comparisons:")
            printToLookLikeCode(actualOutput)
        }
    }
    
    @inlinable
    public func test_protocol_minimumNumberOfComparisons() {
        var actualOutput: [Int: Int] = [:]
        var succeeded: Bool = true
        
        for (inputCount, expectedNumberOfComparisons) in expectedMinimumNumberOfComparisons {
            let actualNumberOfComparisons = Target.minimumNumberOfComparisons(for: inputCount)
            actualOutput[inputCount] = actualNumberOfComparisons
            succeeded = succeeded && actualNumberOfComparisons == expectedNumberOfComparisons
            XCTAssertEqual(actualNumberOfComparisons, expectedNumberOfComparisons)
        }
        
        if !succeeded {
            print("<\(Target.self)> Actual Minimum Number of Comparisons:")
            printToLookLikeCode(actualOutput)
        }
    }
    
    @inlinable
    public func test_protocol_complexity() {
        XCTAssertEqual(Target.complexity, expectedComplexity)
    }
    
    @inlinable
    public func test_protocol_label() {
        XCTAssertEqual(Target.label, expectedLabel)
    }
    
    @inlinable
    public func test_peekAtElement() {
        let input = [1, 2]
        let sort = target(for: input)
        
        XCTAssertEqual(sort.peekAtElement(for: .left), 1)
        XCTAssertEqual(sort.peekAtElement(for: .right), 2)
    }
    
    @inlinable
    public func test_peekAtElement_whileFinished() {
        let finishedSort = perform(inputCase: .worst, inputCount: defaultSortingAlgorithmTestInputCount)
        
        XCTAssertNil(finishedSort.peekAtElement(for: .left))
        XCTAssertNil(finishedSort.peekAtElement(for: .right))
    }
    
    // MARK: Public Instance Interface
    
    @inlinable
    public func helpTestAlgorithIdempotency(
        inputCase: SortingAlgorithmInputCase,
        inputCount: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let input = inputFactory.make(inputCase, count: inputCount)
        let sort = target(for: input)
        
        perform(sort) { previousSort, comparison, currentSort in
            var nextSort = currentSort
            let _ = nextSort()
            
            var extraneousSort = nextSort
            let _ = extraneousSort()
            
            XCTAssertNotEqual(currentSort, previousSort, file: file, line: line)
            XCTAssertEqual(extraneousSort, nextSort, file: file, line: line)
        }
    }
    
    @inlinable
    public func helpTestAlgorithmStability(
        inputCase: SortingAlgorithmInputCase,
        inputCount: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let input = inputFactory.make(inputCase, count: inputCount)
        let sort = target(for: input)
        let expectedOutput = input.sorted()
        
        let finishedSort = perform(sort) { previousSort, comparison, currentSort in
            // The test uses the Comparable implementation for convenience so we want to double-check that the sort
            // will still be correct when the non-Comparable interface is used.
            if comparison.left < comparison.right {
                XCTAssertEqual(comparison(.left), currentSort, file: file, line: line)
            } else {
                XCTAssertEqual(comparison(.right), currentSort, file: file, line: line)
            }
        }
        
        var mutableFinishedSort = finishedSort

        XCTAssertEqual(finishedSort.output, expectedOutput, file: file, line: line)
        XCTAssertEqual(mutableFinishedSort().output, expectedOutput, file: file, line: line)
    }
    
    @inlinable
    public func helpTestProtocolAnswerWhileFinished(
        inputCase: SortingAlgorithmInputCase,
        inputCount: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let finishedSort = perform(inputCase: inputCase, inputCount: inputCount)
        
        var mutatedFinishedSort = finishedSort
        mutatedFinishedSort.answer(.left)
        mutatedFinishedSort.answer(.right)
        
        XCTAssertEqual(finishedSort, mutatedFinishedSort, file: file, line: line)
    }
    
    @discardableResult
    @inlinable
    public func perform(_ sort: Target, comparisonCompletion: ComparisonCompletion? = nil) rethrows -> Target {
        var sort = sort
        var previousSort: Target? = nil
        
        while let comparison = sort().comparison {
            sort = comparison()
            try comparisonCompletion?(previousSort, comparison, sort)
            previousSort = sort
        }
        
        return sort
    }
    
    @discardableResult
    @inlinable
    public func perform(
        inputCase: SortingAlgorithmInputCase,
        inputCount: Int,
        comparisonCompletion: ComparisonCompletion? = nil
    ) rethrows -> Target {
        let input = inputFactory.make(inputCase, count: inputCount)
        let sort = target(for: input)
        
        return try perform(sort, comparisonCompletion: comparisonCompletion)
    }
    
    @inlinable
    public func printToLookLikeCode(_ dictionary: [Int: Int]) {
        var result = "[\n"
        
        for (key, value) in dictionary.sorted(by: { $0.key < $1.key }) {
            result += "    \(key): \(value),\n"
        }
        
        result += "]"
        
        print(result)
    }
}
