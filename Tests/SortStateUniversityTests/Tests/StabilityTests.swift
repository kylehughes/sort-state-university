//
//  StabilityTests.swift
//  Sort State University
//
//  Created by Kyle Hughes on 7/8/26.
//

import XCTest

@testable import SortStateUniversity

/// Tests that the stable sorting algorithms keep equal elements in their original relative order when comparisons
/// are answered with the `Comparable` convenience, which answers ties with the left side.
///
/// The elements only expose their keys to the comparison; their original positions are used solely to verify the
/// output. Quicksort is intentionally absent because it is not a stable algorithm.
final class StabilityTests: XCTestCase {
    private let keys = [1, 1, 2, 2, 3]

    // MARK: Tests

    func test_bubbleSort_isStable() {
        assertSortIsStable { BubbleSort(input: $0) }
    }

    func test_insertionSort_isStable() {
        assertSortIsStable { InsertionSort(input: $0) }
    }

    func test_mergeSort_isStable() {
        assertSortIsStable { MergeSort(input: $0) }
    }

    // MARK: Private Instance Interface

    private func assertSortIsStable<Algorithm>(
        _ makeAlgorithm: ([Record]) -> Algorithm,
        file: StaticString = #filePath,
        line: UInt = #line
    ) where Algorithm: SortingAlgorithm, Algorithm.Element == Record {
        for permutation in Array(0 ..< keys.count).allPermutations() {
            let input = permutation.enumerated().map { Record(key: keys[$0.element], sequence: $0.offset) }
            let output = makeAlgorithm(input).runToCompletion().output

            XCTAssertEqual(output.map(\.key), input.map(\.key).sorted(), file: file, line: line)

            for index in output.indices.dropFirst() where output[index - 1].key == output[index].key {
                XCTAssertLessThan(
                    output[index - 1].sequence,
                    output[index].sequence,
                    "Equal elements reordered for input \(input)",
                    file: file,
                    line: line
                )
            }
        }
    }
}

// MARK: - StabilityTests.Record Definition

extension StabilityTests {
    /// An element with an identity beyond its comparable key, for observing whether equal elements are reordered.
    private struct Record: Comparable {
        let key: Int
        let sequence: Int

        // MARK: Static Interface

        static func < (lhs: Record, rhs: Record) -> Bool {
            lhs.key < rhs.key
        }
    }
}
