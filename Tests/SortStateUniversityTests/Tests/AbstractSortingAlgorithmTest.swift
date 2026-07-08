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
    
    public var expectedAverageNumberOfComparisons: [Int: Double] {
        fatalError("Must be implemented by subclass.")
    }

    public var expectedMaximumNumberOfComparisons: [Int: Double] {
        fatalError("Must be implemented by subclass.")
    }

    public var expectedMinimumNumberOfComparisons: [Int: Double] {
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
        helpTestNumberOfComparisons(
            expected: expectedAverageNumberOfComparisons,
            actual: Target.averageNumberOfComparisons(for:),
            label: "Average"
        )
    }

    @inlinable
    public func test_protocol_maximumNumberOfComparisons() {
        helpTestNumberOfComparisons(
            expected: expectedMaximumNumberOfComparisons,
            actual: Target.maximumNumberOfComparisons(for:),
            label: "Maximum"
        )
    }

    @inlinable
    public func test_protocol_minimumNumberOfComparisons() {
        helpTestNumberOfComparisons(
            expected: expectedMinimumNumberOfComparisons,
            actual: Target.minimumNumberOfComparisons(for:),
            label: "Minimum"
        )
    }

    /// Exhaustively verifies the comparison-count functions against the algorithm's actual behavior.
    ///
    /// For every permutation of every input size up to 7, the algorithm is executed to completion and its comparisons
    /// are counted. The observed minimum, maximum, and average must match `minimumNumberOfComparisons(for:)`,
    /// `maximumNumberOfComparisons(for:)`, and `averageNumberOfComparisons(for:)` exactly, and every run must produce
    /// sorted output. This grounds the closed-form formulas in the implementation itself rather than in tables that
    /// were derived from the formulas.
    @inlinable
    public func test_protocol_numberOfComparisons_matchesActualAlgorithmBehavior() {
        for n in 0 ... 7 {
            let inputs = Array(0 ..< n).allPermutations()
            var minimum = Int.max
            var maximum = Int.min
            var total = 0

            for input in inputs {
                let (output, numberOfComparisons) = target(for: input).runToCompletion()

                XCTAssertEqual(output, input.sorted(), "n=\(n) input=\(input)")

                minimum = Swift.min(minimum, numberOfComparisons)
                maximum = Swift.max(maximum, numberOfComparisons)
                total += numberOfComparisons
            }

            let average = Double(total) / Double(inputs.count)

            XCTAssertEqual(Double(minimum), Target.minimumNumberOfComparisons(for: n), "n=\(n)")
            XCTAssertEqual(Double(maximum), Target.maximumNumberOfComparisons(for: n), "n=\(n)")
            XCTAssertEqual(average, Target.averageNumberOfComparisons(for: n), accuracy: 0.000001, "n=\(n)")
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
        var sort = target(for: input)
        _ = sort()
        
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
    public func helpTestNumberOfComparisons(
        expected: [Int: Double],
        actual: (Int) -> Double,
        label: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let accuracy = 0.0001
        var actualOutput: [Int: Double] = [:]
        var succeeded = true

        for (inputCount, expectedNumberOfComparisons) in expected {
            let actualNumberOfComparisons = actual(inputCount)
            actualOutput[inputCount] = actualNumberOfComparisons
            succeeded = succeeded && abs(actualNumberOfComparisons - expectedNumberOfComparisons) <= accuracy
            XCTAssertEqual(actualNumberOfComparisons, expectedNumberOfComparisons, accuracy: accuracy, file: file, line: line)
        }

        if !succeeded {
            print("<\(Target.self)> Actual \(label) Number of Comparisons:")
            printToLookLikeCode(actualOutput)
        }
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
    public func printToLookLikeCode(_ dictionary: [Int: Double]) {
        var result = "[\n"

        for (key, value) in dictionary.sorted(by: { $0.key < $1.key }) {
            let formattedValue = value == value.rounded() ? String(Int(value)) : String(format: "%.6f", value)
            result += "    \(key): \(formattedValue),\n"
        }

        result += "]"

        print(result)
    }
}
