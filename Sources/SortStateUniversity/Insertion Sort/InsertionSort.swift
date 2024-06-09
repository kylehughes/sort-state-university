//
//  InsertionSort.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 6/22/21.
//

import Foundation

/// A simple sorting algorithm that sorts its elements one at a time.
///
/// - SeeAlso: https://en.wikipedia.org/wiki/Insertion_sort
public struct InsertionSort<Element>: Identifiable {
    /// A type that represents the collection of the elements that the algorithm is sorting.
    public typealias Elements = Array<Element>
    
    /// The stable identity of the algorithm.
    public let id: UUID
    
    /// The given elements that the algorithm is sorting.
    ///
    /// This value is constant and will not change after instantiation.
    public let input: Elements
    
    /// The current result of applying the sorting algorithm to `input`.
    ///
    /// This value is "live" and will change as the algorithm is executed. When the algorithm is finished this value
    /// will contain the sorted result of `input`. It is primarily exposed to allow the internals of the algorithm to
    /// be observed.
    ///
    /// This value should not be used as the final output of the algorithm unless it is known that the algorithm has
    /// finished. It may be easier to perform `callAsFunction()` and respond to the step that is returned – the output
    /// will be reported through that function if the algorithm is finished.
    ///
    /// - SeeAlso: `outputAfterTransactions`
    public private(set) var output: Elements
    
    /// The position (in `output`) of the element that is currently being sorted.
    public private(set) var sortingElementIndex: Elements.Index
    
    /// The position (in `output`) that is one greater than the last sorted element in `output`.
    ///
    /// `output` is sorted when this value is equal to `output.endIndex`.
    public private(set) var sortedEndIndex: Elements.Index
    
    // MARK: Public Initialization
    
    /// Creates an algorithm to sort the given input using insertion sort.
    ///
    /// - Parameter input: The elements to sort.
    public init(input: Elements) {
        self.input = input
        
        id = UUID()
        output = input
        sortingElementIndex = output.index(after: output.startIndex)
        sortedEndIndex = sortingElementIndex
    }
    
    // MARK: Private Instance Interface
    
    private var adjacentSortedElementIndex: Elements.Index {
        output.index(before: sortingElementIndex)
    }
    
    private var isNotFinished: Bool {
        sortedEndIndex < output.endIndex
    }

    private mutating func advanceToNextIndexToSort() {
        output.formIndex(after: &sortedEndIndex)
        sortingElementIndex = sortedEndIndex
    }
    
    @discardableResult
    private mutating func swapSortingElementWithAdjacentSortedElement() -> Elements.Index {
        let sortedElementIndex = adjacentSortedElementIndex
        output.swapAt(sortingElementIndex, sortedElementIndex)
        
        return sortedElementIndex
    }
    
    private mutating func swapSortingElementWithAdjacentSortedElementAndAdvanceToNextComparison() {
        let newSortingElementIndex = swapSortingElementWithAdjacentSortedElement()
        
        if output.startIndex < newSortingElementIndex {
            sortingElementIndex = newSortingElementIndex
        } else {
            advanceToNextIndexToSort()
        }
    }
}

// MARK: - SortingAlgorithm Extension

extension InsertionSort: SortingAlgorithm {
    // MARK: Public Static Interface
    
    /// The runtime complexity of the algorithm.
    @inlinable
    public static var complexity: Complexity {
        .quadratic
    }
    
    /// The unique name of the sorting algorithm.
    @inlinable
    public static var label: SortingAlgorithmLabel {
        .insertion
    }
    
    /// Returns the average number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require more or less comparisons depending on the state of the input and the answers to the
    /// comparisons.
    ///
    /// The average case for insertion sort is approximately `n^2 / 4` comparisons.
    ///
    /// - Parameter n: The number of elements.
    /// - Returns: The average number of comparisons that the algorithm will perform.
    @inlinable
    public static func averageNumberOfComparisons(for n: Int) -> Int {
        // This is a Swift port of the algorithm from "Introduction to Algorithms" by Cormen, Leiserson, Rivest, and
        // Stein, Chapter 2, Section 2.1.
        
        guard 1 < n else {
            return 0
        }
        
        return n * (n - 1) / 4
    }

    /// Returns the maximum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require less comparisons depending on the state of the input and the answers to the
    /// comparisons.
    ///
    /// The maximum number of comparisons in insertion sort is when the input array is sorted in reverse order, which
    /// is approximately `n^2 / 2` comparisons.
    ///
    /// - Parameter n: The number of elements.
    /// - Returns: The maximum number of comparisons that the algorithm will perform.
    @inlinable
    public static func maximumNumberOfComparisons(for n: Int) -> Int {
        // This is a Swift port of the algorithm from "Introduction to Algorithms" by Cormen, Leiserson, Rivest, and
        // Stein, Chapter 2, Section 2.1.
        
        guard 1 < n else {
            return 0
        }
        
        return n * (n - 1) / 2
    }

    /// Returns the minimum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require more comparisons depending on the state of the input and the answers to the
    /// comparisons.
    ///
    /// The minimum number of comparisons in insertion sort is when the input array is already sorted, which is 
    /// approximately `n - 1` comparisons.
    ///
    /// - Parameter n: The number of elements.
    /// - Returns: The minimum number of comparisons that the algorithm will perform.
    @inlinable
    public static func minimumNumberOfComparisons(for n: Int) -> Int {
        // This is a Swift port of the algorithm from "Introduction to Algorithms" by Cormen, Leiserson, Rivest, and
        // Stein, Chapter 2, Section 2.1.
        
        guard 1 < n else {
            return 0
        }
        
        return n - 1
    }
    
    // MARK: Public Instance Interface
    
    @inlinable
    public var isFinished: Bool {
        output.endIndex <= sortedEndIndex
    }
    
    /// Answers the current comparison with the given side.
    ///
    /// The algorithm is advanced to the state that follows the answer.
    ///
    /// If the algorithm is not at a point of comparison then this function will have no effect.
    ///
    /// - Parameter answer: The answer to the current comparison.
    public mutating func answer(_ answer: Comparison<Self>.Side) {
        guard isNotFinished else {
            return
        }
        
        switch answer {
        case .left:
            advanceToNextIndexToSort()
        case .right:
            swapSortingElementWithAdjacentSortedElementAndAdvanceToNextComparison()
        }
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
    public func callAsFunction() -> SortingAlgorithmStep<Self> {
        guard isNotFinished else {
            return .finished(output)
        }

        return .comparison(Comparison(source: self))
    }
    
    /// Returns the element that represents the given side of the current comparison.
    ///
    /// If the algorithm is not at a point of comparison then `nil` will be returned. For example, if the
    /// algorithm has not started or is finished then `nil` will be returned.
    ///
    /// - Parameter answer: The answer that represents the side of the comparison to peek at.
    /// - Returns: The element that represents the given side of the current comparison, or `nil` if the algorithm
    ///   is not at a point of comparison.
    public func peekAtElement(for answer: Comparison<InsertionSort<Element>>.Side) -> Element? {
        guard isNotFinished else {
            return nil
        }
        
        switch answer {
        case .left:
            return output[adjacentSortedElementIndex]
        case .right:
            return output[sortingElementIndex]
        }
    }
}

// MARK: - Decodable Extension

extension InsertionSort: Decodable where Element: Decodable {
    // NO-OP
}

// MARK: - Encodable Extension

extension InsertionSort: Encodable where Element: Encodable {
    // NO-OP
}

// MARK: - Equatable Extension

extension InsertionSort: Equatable where Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension InsertionSort: Hashable where Element: Hashable {
    // NO-OP
}
