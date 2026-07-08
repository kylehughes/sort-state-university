//
//  Quicksort.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 6/22/24.
//

import Foundation

/// A divide-and-conquer sorting algorithm using a pivot for partitioning.
///
/// - SeeAlso: https://en.wikipedia.org/wiki/Quicksort
public struct Quicksort<Element>: Identifiable {
    /// A type that represents the collection of the elements that the algorithm is sorting.
    public typealias Elements = [Element]
    
    /// The stable identity of the algorithm.
    public let id: UUID
    
    /// The given elements that the algorithm is sorting.
    ///
    /// This value is constant and will not change after instantiation.
    public let input: Elements
    
    /// The current partition being sorted.
    public private(set) var currentPartition: Partition?
    
    /// The current result of applying the sorting algorithm to `input`.
    ///
    /// This value is "live" and will change as the algorithm is executed. When the algorithm is finished this value
    /// will contain the sorted result of `input`. It is primarily exposed to allow the internals of the algorithm to
    /// be observed.
    public private(set) var output: Elements
    
    /// A stack of partitions to be sorted.
    public private(set) var partitionStack: [Partition]
    
    // MARK: Public Initialization
    
    /// Creates an algorithm to sort the given input using quicksort.
    ///
    /// - Parameter input: The elements to sort.
    public init(input: Elements) {
        self.input = input
        
        currentPartition = nil
        id = UUID()
        output = input
        partitionStack = []

        pushPartition(low: input.startIndex, high: input.index(before: input.endIndex))
    }

    // MARK: Internal Instance Interface

    @usableFromInline
    internal var pendingComparisonPartition: Partition? {
        guard let currentPartition, currentPartition.hasPendingComparison else {
            return nil
        }

        return currentPartition
    }

    // MARK: Private Instance Interface

    private mutating func pushPartition(low: Elements.Index, high: Elements.Index) {
        guard low < high else {
            return
        }

        partitionStack.append(Partition(low: low, high: high))
    }
}

// MARK: - SortingAlgorithm Extension

extension Quicksort: SortingAlgorithm {
    // MARK: Public Static Interface
    
    @inlinable
    public static var complexity: Complexity {
        .linearithmic
    }
    
    @inlinable
    public static var label: SortingAlgorithmLabel {
        .quicksort
    }
    
    /// Returns the average number of comparisons that quicksort will perform given an input with `n` elements.
    ///
    /// The average number of comparisons in quicksort is calculated using the formula `E[Cₙ] = 2(n + 1)Hₙ - 4n`, where
    /// `Hₙ` is the nth harmonic number.
    ///
    /// This calculation is based on the following analysis:
    ///
    /// 1. **Indicator Random Variables:**
    ///    - Define `I₍i,j₎` as an indicator random variable where `I₍i,j₎ = 1` if elements `i` and `j` are compared
    ///      during the execution of quicksort, and `0` otherwise.
    ///
    /// 2. **Expected Number of Comparisons:**
    ///    - The total expected number of comparisons is:
    ///      ```
    ///      E[Cₙ] = ∑_{1 ≤ i < j ≤ n} E[I₍i,j₎] = ∑_{1 ≤ i < j ≤ n} 2 / (j - i + 1)
    ///      ```
    ///
    /// 3. **Simplifying Using Harmonic Numbers:**
    ///    - The expected number of comparisons simplifies to:
    ///      ```
    ///      E[Cₙ] = 2(n + 1)Hₙ - 4n
    ///      ```
    ///      where `Hₙ` is the `n`th harmonic number.
    ///
    /// - Note: Based on the average-case analysis of quicksort as described in **Introduction to Algorithms** by
    ///   Cormen, Leiserson, Rivest, and Stein.
    /// - Parameter n: The number of elements.
    /// - Returns: The average number of comparisons that the algorithm will perform.
    @inlinable
    public static func averageNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }

        let nDouble = Double(n)
        
        return 2 * (nDouble + 1) * n.harmonicNumber - 4 * nDouble
    }

    /// Returns the maximum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The worst case for quicksort occurs when the pivot is always the smallest or largest element.
    ///
    /// - SeeAlso: Cormen, T. H., Leiserson, C. E., Rivest, R. L., & Stein, C. (2009). Introduction to Algorithms
    ///   (3rd ed.). MIT Press. Section 7.4.1: The worst-case partitioning.
    /// - Parameter n: The number of elements.
    /// - Returns: The maximum number of comparisons that the algorithm will perform.
    @inlinable
    public static func maximumNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }
        
        return Double((n * (n - 1))) / 2.0
    }

    /// Returns the minimum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The best case for quicksort occurs when the pivot always divides the remaining elements into two halves that
    /// are as equal as possible. Partitioning `n` elements always costs exactly `n - 1` comparisons, and both halves
    /// are then sorted recursively, so the minimum satisfies the recurrence
    /// `C(n) = (n - 1) + C(⌊(n - 1)/2⌋) + C(⌈(n - 1)/2⌉)` with `C(0) = C(1) = 0`.
    ///
    /// - SeeAlso: Knuth, D. E. (1998). The Art of Computer Programming, Volume 3: Sorting and Searching (2nd ed.).
    ///   Addison-Wesley Professional. Section 5.2.2: Sorting by exchanging.
    /// - Parameter n: The number of elements.
    /// - Returns: The minimum number of comparisons that the algorithm will perform.
    public static func minimumNumberOfComparisons(for n: Int) -> Double {
        var memo: [Int: Int] = [:]

        func minimumComparisons(toSort count: Int) -> Int {
            guard 1 < count else {
                return 0
            }

            if let cached = memo[count] {
                return cached
            }

            let remainder = count - 1
            let result = remainder
                + minimumComparisons(toSort: remainder / 2)
                + minimumComparisons(toSort: remainder - remainder / 2)

            memo[count] = result

            return result
        }

        return Double(minimumComparisons(toSort: n))
    }
    
    // MARK: Public Instance Interface
    
    @inlinable
    public var isFinished: Bool {
        partitionStack.isEmpty && currentPartition == nil
    }
    
    public mutating func answer(_ answer: Comparison<Self>.Side) {
        guard var partition = pendingComparisonPartition else {
            return
        }
        
        switch answer {
        case .left:
            output.swapAt(partition.currentIndex, partition.partitionIndex)
            partition.partitionIndex += 1
            partition.currentIndex += 1
        case .right:
            partition.currentIndex += 1
        }
        
        currentPartition = partition
    }

    public mutating func callAsFunction() -> SortingAlgorithmStep<Self> {
        guard !isFinished else {
            return .finished(output)
        }
        
        if currentPartition == nil {
            guard let nextPartition = partitionStack.popLast() else {
                return .finished(output)
            }
            
            currentPartition = nextPartition
        }
        
        guard let partition = currentPartition else {
            return .finished(output)
        }
        
        guard !partition.hasPendingComparison else {
            return .comparison(Comparison(source: self))
        }

        output.swapAt(partition.partitionIndex, partition.high)

        let pivotIndex = partition.partitionIndex

        pushPartition(low: partition.low, high: pivotIndex - 1)
        pushPartition(low: pivotIndex + 1, high: partition.high)

        currentPartition = nil
        
        return self()
    }

    @inlinable
    public func peekAtElement(for answer: Comparison<Self>.Side) -> Element? {
        guard let partition = pendingComparisonPartition else {
            return nil
        }
        
        switch answer {
        case .left:
            return output[partition.currentIndex]
        case .right:
            return output[partition.high]
        }
    }
}

// MARK: - Decodable Extension

extension Quicksort: Decodable where Element: Decodable {
    // NO-OP
}

// MARK: - Encodable Extension

extension Quicksort: Encodable where Element: Encodable {
    // NO-OP
}

// MARK: - Equatable Extension

extension Quicksort: Equatable where Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension Quicksort: Hashable where Element: Hashable {
    // NO-OP
}
