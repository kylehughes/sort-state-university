//
//  MergeSort.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

/// A divide-and-conquer sorting algorithm.
///
/// - SeeAlso: https://en.wikipedia.org/wiki/Merge_sort
public struct MergeSort<Element>: Identifiable {
    /// A type that represents the collection of the elements that the algorithm is sorting.
    public typealias Elements = Array<Element>
    
    /// The stable identity of the algorithm.
    public let id: UUID
    
    /// The given elements that the algorithm is sorting.
    ///
    /// This value is constant and will not change after instantiation.
    public let input: Elements
    
    /// The position of the first element in the left paritition to be merged.
    ///
    /// Whether the algorithm is finished or not cannot be inferred from this value.
    public private(set) var currentIndex: Elements.Index
    
    /// The merge that is currently underway.
    ///
    /// This value will be `nil` when the algorithm has not started and when the algorithm is finished. Otherwise,
    /// a merge will always be ongoing and a value will always be returned.
    public private(set) var ongoingMerge: Merge?
    
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
    
    /// The number of elements in each partition being merged.
    ///
    /// The algorithm is finished when this value is greater-than-or-equal-to the number of elements in `input`.
    public private(set) var partitionSize: Int
    
    // MARK: Public Initialization
    
    /// Creates an algorithm to sort the given input using bottom-up merge sort.
    ///
    /// - Parameter input: The elements to sort.
    public init(input: Elements) {
        self.input = input
        
        currentIndex = input.startIndex
        id = UUID()
        ongoingMerge = nil
        output = input
        partitionSize = 1
        
        _ = self()
    }
    
    // MARK: Public Instance Interface
    
    /// The value of `output` after applying the uncommitted transactions from the ongoing merge.
    ///
    /// This should not be used for general access to `output`.
    ///
    /// This is useful for observing the merging process happen to `output`. Due to implementation details, the outcome
    /// of a single merge will only be applied after all of the comparisons for that merge have been answered. Thus,
    /// `output` will only update in `partitionSize * 2`-sized chunks. This value allows a caller to inspect `output`
    /// with all of the in-flight transactions from the merge applied, which will show the merge happen step-by-step to
    /// the partitions within `output`.
    ///
    /// If there is no ongoing merge then this value will be equal to `output`.
    ///
    /// - SeeAlso: `MergeSort.Merge.output`
    @inlinable
    public var outputAfterTransactions: Elements {
        guard let ongoingMerge = ongoingMerge else {
            return output
        }
        
        return output.performing(ongoingMerge.output)
    }
    
    // MARK: Private Instance Interface
    
    private func finish() -> SortingAlgorithmStep<Self>? {
        guard partitionSize < input.endIndex else {
            return .finished(output)
        }
        
        return nil
    }
    
    private mutating func iterateCursorLoop() -> SortingAlgorithmStep<Self> {
        let fromIndex = currentIndex
        let middleIndex = fromIndex + partitionSize - 1
        let toIndex = min(fromIndex + (2 * partitionSize) - 1, input.endIndex - 1)
        
        ongoingMerge = Merge(fromIndex: fromIndex, middleIndex: middleIndex, toIndex: toIndex)
        
        return self()
    }
    
    private mutating func iterateMerge() -> SortingAlgorithmStep<Self>? {
        guard ongoingMerge != nil else {
            return nil
        }
        
        guard let transactions = ongoingMerge!() else {
            return .comparison(Comparison(source: self))
        }
        
        output.perform(transactions)
        currentIndex += 2 * partitionSize
        ongoingMerge = nil
        
        return nil
    }
    
    private mutating func iteratePartitionLoop() -> SortingAlgorithmStep<Self>? {
        guard currentIndex < input.endIndex - partitionSize else {
            currentIndex = output.startIndex
            partitionSize *= 2
            
            return self()
        }
        
        return nil
    }
}

// MARK: - SortingAlgorithm Extension

extension MergeSort: SortingAlgorithm {
    // MARK: Public Static Interface
    
    /// The runtime complexity of the algorithm.
    @inlinable
    public static var complexity: Complexity {
        .linearithmic
    }
    
    /// The unique name of the sorting algorithm.
    @inlinable
    public static var label: SortingAlgorithmLabel {
        .merge
    }
    
    /// Returns the average number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require more or less comparisons depending on the state of the input and the answers to the
    /// comparisons.
    ///
    /// The average case for merge sort is asymptotically `n log2(n) - O(n)`. For practical purposes, we use `n log2(n)`
    /// for large `n`, which provides a good approximation.
    ///
    /// - Parameter n: The number of elements.
    /// - Returns: The average number of comparisons that the algorithm will perform.
    @inlinable
    public static func averageNumberOfComparisons(for n: Int) -> Int {
        // This is a Swift port of the algorithm from "Introduction to Algorithms" by Cormen, Leiserson, Rivest, and
        // Stein, Chapter 2, Section 2.3.
        
        guard 1 < n else {
            return 0
        }
        
        return Int(Double(n) * log2(Double(n)))
    }
    
    /// Returns the maximum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require less comparisons depending on the state of the input and the answers to the
    /// comparisons. The algorithm is guaranteed to not require more comparisons than returned.
    ///
    /// This value is provably correct and precise. It is not an estimate.
    ///
    /// - SeeAlso: https://oeis.org/A003071
    /// - Parameter n: The number of elements.
    /// - Returns: The number of comparisons that the algorithm will perform in the worst case.
    @inlinable
    public static func maximumNumberOfComparisons(for n: Int) -> Int {
        // This is a Swift port of the algorithm from D. E. Knuth, Art of Computer Programming, Vol. 3, Sections 5.2.4.,
        // Problem 14. (https://oeis.org/A003071)
        
        let bitNumbers = n.bitNumbers.sorted(by: >)
        
        guard let lastBitNumber = bitNumbers.last else {
            return 0
        }
        
        var sum = 0
        
        for index in bitNumbers.indices {
            let bitNumber = bitNumbers[index]
            sum += (bitNumber + index) * 2.pow(bitNumber)
        }
        
        return 1 - 2.pow(lastBitNumber) + sum
    }
    
    /// Returns the minimum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require more comparisons depending on the state of the input and the answers to the
    /// comparisons.
    ///
    /// This value is provably correct and precise. It is not an estimate.
    ///
    /// - Parameter n: The number of elements.
    /// - Returns: The minimum number of comparisons that the algorithm will perform.
    @inlinable
    public static func minimumNumberOfComparisons(for n: Int) -> Int {
        // This is a Swift port of the algorithm from "Introduction to Algorithms" by Cormen, Leiserson, Rivest, and
        // Stein, Chapter 2, Section 2.3.
        
        guard 1 < n else {
            return 0
        }
            
        var comparisons = 0
        var currentSize = 1
        
        while currentSize < n {
            comparisons += (n / (currentSize * 2)) * currentSize
            
            if currentSize < n % (currentSize * 2) {
                comparisons += n % currentSize
            }
            
            currentSize *= 2
        }
        
        return comparisons
    }
    
    // MARK: Public Instance Interface
    
    /// Answers the current comparison with the given side.
    ///
    /// The algorithm is advanced to the state that follows the answer.
    ///
    /// If the algorithm is not at a point of comparison then this function will have no effect.
    ///
    /// - Parameter answer: The answer to the current comparison.
    public mutating func answer(_ answer: Comparison<Self>.Side) {
        switch answer {
        case .left:
            ongoingMerge?.answer(.left)
        case .right:
            ongoingMerge?.answer(.right)
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
    public mutating func callAsFunction() -> SortingAlgorithmStep<Self> {
        finish() ?? iterateMerge() ?? iteratePartitionLoop() ?? iterateCursorLoop()
    }
    
    /// Returns the element that represents the given side of the current comparison.
    ///
    /// If the algorithm is not at a point of comparison then `nil` will be returned. For example, if the
    /// algorithm has not started or is finished then `nil` will be returned.
    ///
    /// - Parameter answer: The answer that represents the side of the comparison to peek at.
    /// - Returns: The element that represents the given side of the current comparison, or `nil` if the algorithm
    ///   is not at a point of comparison.
    public func peekAtElement(for answer: Comparison<MergeSort<Element>>.Side) -> Element? {
        guard let ongoingMerge = ongoingMerge else {
            return nil
        }
        
        switch answer {
        case .left:
            return output[ongoingMerge.leftPartitionIndex]
        case .right:
            return output[ongoingMerge.rightPartitionIndex]
        }
    }
}

// MARK: - Decodable Extension

extension MergeSort: Decodable where Element: Decodable {
    // NO-OP
}

// MARK: - Encodable Extension

extension MergeSort: Encodable where Element: Encodable {
    // NO-OP
}

// MARK: - Equatable Extension

extension MergeSort: Equatable where Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension MergeSort: Hashable where Element: Hashable {
    // NO-OP
}
