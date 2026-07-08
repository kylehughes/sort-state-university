//
//  MergeSort.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

/// A divide-and-conquer sorting algorithm that recursively splits and merges sublists.
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
    
    /// The current result of applying the sorting algorithm to ``input``.
    ///
    /// This value is "live" and will change as the algorithm is executed. When the algorithm is finished this value
    /// will contain the sorted result of ``input``. It is primarily exposed to allow the internals of the algorithm to
    /// be observed.
    ///
    /// This value should not be used as the final output of the algorithm unless it is known that the algorithm has
    /// finished. It may be easier to perform ``callAsFunction()`` and respond to the step that is returned – the output
    /// will be reported through that function if the algorithm is finished.
    ///
    /// - SeeAlso: `outputAfterTransactions`
    public private(set) var output: Elements
    
    /// The number of elements in each partition being merged.
    ///
    /// The algorithm is finished when this value is greater-than-or-equal-to the number of elements in ``input``.
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
    }
    
    // MARK: Public Instance Interface
    
    /// The value of ``output`` after applying the uncommitted transactions from the ongoing merge.
    ///
    /// This should not be used for general access to ``output``.
    ///
    /// This is useful for observing the merging process happen to ``output``. Due to implementation details, the
    /// outcome of a single merge will only be applied after all of the comparisons for that merge have been answered.
    /// Thus, ``output`` will only update in `partitionSize * 2`-sized chunks. This value allows a caller to inspect
    /// ``output`` with all of the in-flight transactions from the merge applied, which will show the merge happen
    /// step-by-step to the partitions within ``output``.
    ///
    /// If there is no ongoing merge then this value will be equal to ``output``.
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
    
    @inlinable
    public static var complexity: Complexity {
        .linearithmic
    }
    
    @inlinable
    public static var label: SortingAlgorithmLabel {
        .mergeSort
    }
    
    /// Returns the average number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The average is taken over all permutations of `n` distinct elements, each equally likely. It is exact, not an
    /// estimate.
    ///
    /// Merging sorted runs of lengths `m` and `k` whose combined relative order is uniformly random requires
    /// `m + k - m/(k + 1) - k/(m + 1)` comparisons on average. This implementation is a bottom-up merge sort, so the
    /// total is that expectation summed over every merge in the doubling partition schedule: at each pass,
    /// `⌊n / 2p⌋` merges of two runs of length `p`, plus a final merge of runs of lengths `p` and `(n mod 2p) - p`
    /// when the leftover is longer than one run.
    ///
    /// - Note: The per-merge expectation is from the analysis of merging in D. E. Knuth, *The Art of Computer
    ///   Programming*, Volume 3, Section 5.2.4.
    /// - Parameter n: The number of elements.
    /// - Returns: The average number of comparisons that the algorithm will perform.
    public static func averageNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }

        func averageComparisonsForMerge(_ m: Int, _ k: Int) -> Double {
            let m = Double(m)
            let k = Double(k)

            return m + k - m / (k + 1) - k / (m + 1)
        }

        var comparisons = 0.0
        var partitionSize = 1

        while partitionSize < n {
            let mergedSize = partitionSize * 2
            let numberOfFullMerges = n / mergedSize
            let remainder = n % mergedSize

            comparisons += Double(numberOfFullMerges) * averageComparisonsForMerge(partitionSize, partitionSize)

            if partitionSize < remainder {
                comparisons += averageComparisonsForMerge(partitionSize, remainder - partitionSize)
            }

            partitionSize = mergedSize
        }

        return comparisons
    }
    
    /// Returns the maximum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require less comparisons depending on the state of the input and the answers to the
    /// comparisons. The algorithm is guaranteed to not require more comparisons than returned.
    ///
    /// This value is provably correct and precise. It is not an estimate.
    ///
    /// - Note: This is a Swift port of the algorithm from D. E. Knuth, Art of Computer Programming, Vol. 3, 
    ///   Sections 5.2.4., Problem 14.
    /// - SeeAlso: [https://oeis.org/A003071](https://oeis.org/A003071)
    /// - Parameter n: The number of elements.
    /// - Returns: The number of comparisons that the algorithm will perform in the worst case.
    @inlinable
    public static func maximumNumberOfComparisons(for n: Int) -> Double {
        let bitNumbers = n.bitNumbers.sorted(by: >)
        
        guard let lastBitNumber = bitNumbers.last else {
            return 0
        }
        
        var sum = 0
        
        for index in bitNumbers.indices {
            let bitNumber = bitNumbers[index]
            sum += (bitNumber + index) * (1 << bitNumber)
        }

        return Double(1 - (1 << lastBitNumber) + sum)
    }
    
    /// Returns the minimum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The algorithm may require more comparisons depending on the state of the input and the answers to the
    /// comparisons.
    ///
    /// This value is provably correct and precise. It is not an estimate.
    ///
    /// - Note: This is a Swift port of the algorithm from "Introduction to Algorithms" by Cormen, Leiserson, Rivest, 
    ///   and Stein, Chapter 2, Section 2.3.
    /// - Parameter n: The number of elements.
    /// - Returns: The minimum number of comparisons that the algorithm will perform.
    @inlinable
    public static func minimumNumberOfComparisons(for n: Int) -> Double {
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
        
        return Double(comparisons)
    }
    
    // MARK: Public Instance Interface
    
    @inlinable
    public var isFinished: Bool {
        input.endIndex <= partitionSize
    }
    
    public mutating func answer(_ answer: Comparison<Self>.Side) {
        switch answer {
        case .left:
            ongoingMerge?.answer(.left)
        case .right:
            ongoingMerge?.answer(.right)
        }
    }
    
    public mutating func callAsFunction() -> SortingAlgorithmStep<Self> {
        finish() ?? iterateMerge() ?? iteratePartitionLoop() ?? iterateCursorLoop()
    }
    
    @inlinable
    public func peekAtElement(for answer: Comparison<MergeSort<Element>>.Side) -> Element? {
        guard let ongoingMerge = ongoingMerge, ongoingMerge.arePartitionIndicesInBounds else {
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
