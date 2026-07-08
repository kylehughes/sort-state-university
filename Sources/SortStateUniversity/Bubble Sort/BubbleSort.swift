//
//  BubbleSort.swift
//  Sort State University
//
//  Created by Kyle Hughes on 7/8/26.
//

import Foundation

/// A simple sorting algorithm that repeatedly steps through the elements and swaps adjacent pairs that are out of
/// order.
///
/// Each pass bubbles the largest remaining element to the end of the unsorted region, so the region shrinks by one
/// element per pass. The algorithm finishes early when a pass completes without any swaps, which proves the elements
/// are sorted.
///
/// - SeeAlso: https://en.wikipedia.org/wiki/Bubble_sort
public struct BubbleSort<Element>: Identifiable {
    /// A type that represents the collection of the elements that the algorithm is sorting.
    public typealias Elements = Array<Element>

    /// The stable identity of the algorithm.
    public let id: UUID

    /// The given elements that the algorithm is sorting.
    ///
    /// This value is constant and will not change after instantiation.
    public let input: Elements

    /// The position (in `output`) of the left element of the current comparison.
    public private(set) var currentIndex: Elements.Index

    /// Whether or not any elements have been swapped during the current pass.
    ///
    /// If a pass completes while this value is `false` then `output` is sorted and the algorithm is finished.
    public private(set) var didSwapDuringCurrentPass: Bool

    /// The current result of applying the sorting algorithm to `input`.
    ///
    /// This value is "live" and will change as the algorithm is executed. When the algorithm is finished this value
    /// will contain the sorted result of `input`. It is primarily exposed to allow the internals of the algorithm to
    /// be observed.
    ///
    /// This value should not be used as the final output of the algorithm unless it is known that the algorithm has
    /// finished. It may be easier to perform `callAsFunction()` and respond to the step that is returned – the output
    /// will be reported through that function if the algorithm is finished.
    public private(set) var output: Elements

    /// The position (in `output`) that is one greater than the last element that is not yet known to be sorted.
    ///
    /// Each pass compares the adjacent pairs before this position and then moves it back by one. The algorithm is
    /// finished when this value is less than or equal to the position after `output.startIndex`; when a pass
    /// completes without any swaps the algorithm finishes early and this value collapses there directly.
    public private(set) var unsortedEndIndex: Elements.Index

    // MARK: Public Initialization

    /// Creates an algorithm to sort the given input using bubble sort.
    ///
    /// - Parameter input: The elements to sort.
    public init(input: Elements) {
        self.input = input

        currentIndex = input.startIndex
        didSwapDuringCurrentPass = false
        id = UUID()
        output = input
        unsortedEndIndex = input.endIndex
    }

    // MARK: Internal Instance Interface

    @usableFromInline
    internal var hasPendingComparison: Bool {
        output.index(after: currentIndex) < unsortedEndIndex
    }
}

// MARK: - SortingAlgorithm Extension

extension BubbleSort: SortingAlgorithm {
    // MARK: Public Static Interface

    /// The runtime complexity of the algorithm.
    @inlinable
    public static var complexity: Complexity {
        .quadratic
    }

    /// The unique name of the sorting algorithm.
    @inlinable
    public static var label: SortingAlgorithmLabel {
        .bubbleSort
    }

    /// Returns the average number of comparisons that bubble sort will perform given an input with `n` elements.
    ///
    /// The average is taken over all permutations of `n` distinct elements, each equally likely. It is exact, not an
    /// estimate.
    ///
    /// This calculation is based on the following analysis:
    ///
    /// 1. **Passes Are Determined by Displacement:**
    ///    - An element moves toward the front by at most one position per pass, so the number of swapping passes
    ///      equals `D`, the maximum distance any element must travel toward the front. One further pass is required
    ///      to observe that no swaps occurred, except when the shrinking boundary ends the algorithm first.
    ///
    /// 2. **Distribution of the Maximum Displacement:**
    ///    - The number of permutations with `D ≤ d` is `(d + 1)! · (d + 1)ⁿ⁻ᵈ⁻¹`.
    ///
    /// 3. **Comparisons for a Given Displacement:**
    ///    - Pass `k` (zero-based) performs `n - 1 - k` comparisons, so a run with maximum displacement `d` performs
    ///      `∑_{k=0}^{min(d, n-2)} (n - 1 - k)` comparisons in total.
    ///
    /// The expectation is the displacement distribution summed against the per-displacement comparison count.
    ///
    /// - Note: Based on the analysis of bubble sort passes as described in **The Art of Computer Programming** by
    ///   Donald E. Knuth, Volume 3: *Sorting and Searching*, Section 5.2.2.
    /// - Parameter n: The number of elements.
    /// - Returns: The average number of comparisons that the algorithm will perform.
    public static func averageNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }

        // P(D ≤ d), computed in log space to avoid overflowing the factorials for large `n`.
        func probabilityOfMaximumDisplacement(upTo d: Int) -> Double {
            guard d < n - 1 else {
                return 1
            }

            let bound = Double(d + 1)

            return exp(lgamma(bound + 1) + Double(n - d - 1) * log(bound) - lgamma(Double(n) + 1))
        }

        func numberOfComparisons(forMaximumDisplacement d: Int) -> Double {
            let passes = Double(Swift.min(d, n - 2) + 1)

            return passes * Double(n - 1) - passes * (passes - 1) / 2
        }

        var expectation = 0.0

        for d in 0 ... n - 1 {
            let probability = probabilityOfMaximumDisplacement(upTo: d)
                - (0 < d ? probabilityOfMaximumDisplacement(upTo: d - 1) : 0)
            expectation += probability * numberOfComparisons(forMaximumDisplacement: d)
        }

        return expectation
    }

    /// Returns the maximum number of comparisons that bubble sort will perform given an input with `n` elements.
    ///
    /// The algorithm may require fewer comparisons depending on the initial order of the input elements.
    ///
    /// The maximum number of comparisons occurs when the input is sorted in reverse order: every pass swaps, so all
    /// `n - 1` passes run and perform `n(n - 1)/2` comparisons in total.
    ///
    /// - Note: Based on the analysis of bubble sort passes as described in **The Art of Computer Programming** by
    ///   Donald E. Knuth, Volume 3: *Sorting and Searching*, Section 5.2.2.
    /// - Parameter n: The number of elements.
    /// - Returns: The maximum number of comparisons that the algorithm will perform.
    @inlinable
    public static func maximumNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }

        return Double(n * (n - 1) / 2)
    }

    /// Returns the minimum number of comparisons that bubble sort will perform given an input with `n` elements.
    ///
    /// The algorithm may require more comparisons depending on the initial order of the input elements.
    ///
    /// The minimum number of comparisons occurs when the input is already sorted: the first pass performs `n - 1`
    /// comparisons without swapping, which finishes the algorithm.
    ///
    /// - Note: Based on the analysis of bubble sort passes as described in **The Art of Computer Programming** by
    ///   Donald E. Knuth, Volume 3: *Sorting and Searching*, Section 5.2.2.
    /// - Parameter n: The number of elements.
    /// - Returns: The minimum number of comparisons that the algorithm will perform.
    @inlinable
    public static func minimumNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }

        return Double(n - 1)
    }

    // MARK: Public Instance Interface

    @inlinable
    public var isFinished: Bool {
        unsortedEndIndex <= output.index(after: output.startIndex)
    }

    /// Answers the current comparison with the given side.
    ///
    /// The algorithm is advanced to the state that follows the answer.
    ///
    /// If the algorithm is not at a point of comparison then this function will have no effect.
    ///
    /// - Parameter answer: The answer to the current comparison.
    public mutating func answer(_ answer: Comparison<Self>.Side) {
        guard hasPendingComparison else {
            return
        }

        switch answer {
        case .left:
            break
        case .right:
            output.swapAt(currentIndex, output.index(after: currentIndex))
            didSwapDuringCurrentPass = true
        }

        output.formIndex(after: &currentIndex)
    }

    /// Executes the algorithm in its current state and, if possible, advances it to the next state and returns the
    /// step to the caller.
    ///
    /// When the algorithm is not finished this function will return the next comparison that needs to
    /// be answered to continue the algorithm. When the algorithm is finished this function will return the sorted
    /// output.
    ///
    /// This function is idempotent: for a given state of the algorithm, calling this function will always produce
    /// the same result and will always leave the algorithm in the same – possibly new – state. Performing this
    /// function consecutively on the same algorithm will have no additional affect.
    ///
    /// - Returns: The next step in the algorithm: either the next comparison to answer, or the sorted output.
    public mutating func callAsFunction() -> SortingAlgorithmStep<Self> {
        guard !isFinished else {
            return .finished(output)
        }

        guard !hasPendingComparison else {
            return .comparison(Comparison(source: self))
        }

        guard didSwapDuringCurrentPass else {
            // A pass without swaps proves that the elements are sorted.
            unsortedEndIndex = output.index(after: output.startIndex)

            return .finished(output)
        }

        currentIndex = output.startIndex
        didSwapDuringCurrentPass = false
        output.formIndex(before: &unsortedEndIndex)

        return self()
    }

    /// Returns the element that represents the given side of the current comparison.
    ///
    /// If the algorithm is not at a point of comparison then `nil` will be returned. For example, if the
    /// algorithm has not started or is finished then `nil` will be returned.
    ///
    /// - Parameter answer: The answer that represents the side of the comparison to peek at.
    /// - Returns: The element that represents the given side of the current comparison, or `nil` if the algorithm
    ///   is not at a point of comparison.
    @inlinable
    public func peekAtElement(for answer: Comparison<BubbleSort<Element>>.Side) -> Element? {
        guard hasPendingComparison else {
            return nil
        }

        switch answer {
        case .left:
            return output[currentIndex]
        case .right:
            return output[output.index(after: currentIndex)]
        }
    }
}

// MARK: - Decodable Extension

extension BubbleSort: Decodable where Element: Decodable {
    // NO-OP
}

// MARK: - Encodable Extension

extension BubbleSort: Encodable where Element: Encodable {
    // NO-OP
}

// MARK: - Equatable Extension

extension BubbleSort: Equatable where Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension BubbleSort: Hashable where Element: Hashable {
    // NO-OP
}
