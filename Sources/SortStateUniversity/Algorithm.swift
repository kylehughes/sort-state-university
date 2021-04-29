//
//  Algorithm.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

/// A stateful sorting algorithm.
public protocol Algorithm: Identifiable {
    // MARK: Associated Types
    
    /// A type that represents the element that the algorithm is sorting.
    associatedtype Element
    
    // MARK: Static Interface
    
    /// The runtime complexity of the algorithm.
    static var complexity: Complexity { get }
    
    static func calculateNumberOfComparisonsInWorstCase(for n: Int) -> NumberOfComparisons

    // MARK: Instance Interface
    
    /// The elements to be sorted.
    ///
    /// This value will never change.
    var input: [Element] { get }
    
    mutating func callAsFunction() -> AlgorithmStep<Self>
    mutating func iterateForAnswer(_ answer: Comparison<Self>.Answer, element: Element)
}

// MARK: - Default Implementation

extension Algorithm {
    // MARK: Public Static Interface
    
    public static func calculateNumberOfComparisonsInWorstCase(for n: Int) -> NumberOfComparisons {
        .ceiling(for: n, using: complexity)
    }
}

// MARK: - Bespoke Implementation

extension Algorithm {
    // MARK: Public Instance Interface
    
    public var numberOfComparisonsInWorstCase: NumberOfComparisons {
        Self.calculateNumberOfComparisonsInWorstCase(for: input.count)
    }
}
