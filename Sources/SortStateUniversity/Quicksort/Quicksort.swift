//
//  Quicksort.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 6/22/24.
//

import Foundation

/// A divide-and-conquer sorting algorithm that uses a pivot element for partitioning the input array.
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
        partitionStack = [Partition(low: input.startIndex, high: input.index(before: input.endIndex))]
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
    
    /// Returns the average number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// This calculation uses the exact recurrence relation for Quicksort's average case.
    ///
    /// - SeeAlso: Sedgewick, R., & Flajolet, P. (1996). An Introduction to the Analysis of Algorithms.
    ///   Addison-Wesley. Section 8.2: Quicksort.
    /// - Parameter n: The number of elements.
    /// - Returns: The average number of comparisons that the algorithm will perform.
    @inlinable
    public static func averageNumberOfComparisons(for n: Int) -> Int {
        guard 1 < n else {
            return 0
        }
        
        var dynamicProgrammingTable = Array(repeating: 0, count: n + 1)
        
        for i in 2...n {
            dynamicProgrammingTable[i] = i - 1 + 2 * (0..<i).reduce(0) { $0 + dynamicProgrammingTable[$1] } / i
        }
        
        return dynamicProgrammingTable[n]
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
    public static func maximumNumberOfComparisons(for n: Int) -> Int {
        guard 1 < n else {
            return 0
        }
        
        return (n * (n - 1)) / 2
    }

    /// Returns the minimum number of comparisons that the algorithm will perform given an input with `n` elements.
    ///
    /// The best case for quicksort occurs when the pivot always divides the array into two equal halves.
    ///
    /// - SeeAlso: Knuth, D. E. (1998). The Art of Computer Programming, Volume 3: Sorting and Searching (2nd ed.). 
    ///   Addison-Wesley Professional. Section 5.2.2: Sorting by exchanging.
    /// - Parameter n: The number of elements.
    /// - Returns: The minimum number of comparisons that the algorithm will perform.
    @inlinable
    public static func minimumNumberOfComparisons(for n: Int) -> Int {
        guard 1 < n else {
            return 0
        }
        
        var result = 0
        var size = n
        
        while 1 < size {
            result += size - 1
            size /= 2
        }
        
        return result
    }
    
    // MARK: Public Instance Interface
    
    @inlinable
    public var isFinished: Bool {
        partitionStack.isEmpty && currentPartition == nil
    }
    
    public mutating func answer(_ answer: Comparison<Self>.Side) {
        guard var partition = currentPartition else {
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
        
        guard partition.currentIndex >= partition.high else {
            return .comparison(Comparison(source: self))
        }
        
        output.swapAt(partition.partitionIndex, partition.high)
        
        let pivotIndex = partition.partitionIndex
        
        if partition.low < pivotIndex {
            partitionStack.append(Partition(low: partition.low, high: pivotIndex - 1))
        }
        
        if pivotIndex + 1 < partition.high {
            partitionStack.append(Partition(low: pivotIndex + 1, high: partition.high))
        }
        
        currentPartition = nil
        
        return self()
    }

    @inlinable
    public func peekAtElement(for answer: Comparison<Self>.Side) -> Element? {
        guard let partition = currentPartition else {
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
