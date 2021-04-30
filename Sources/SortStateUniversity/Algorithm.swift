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
    
    var input: [Element] { get }
    
    mutating func answer(_ answer: Comparison<Self>.Answer)
    mutating func callAsFunction() -> AlgorithmStep<Self>
    func peekAtElement(for answer: Comparison<Self>.Answer) -> Element
}

// MARK: - Default Implementation

extension Algorithm {
    // MARK: Public Static Interface
    
    public static func calculateNumberOfComparisonsInWorstCase(for n: Int) -> NumberOfComparisons {
        .ceiling(for: n, using: complexity)
    }
    
    // MARK: Public Instance Interface
    
    public func answering(_ answer: Comparison<Self>.Answer) -> Self {
        var copy = self
        copy.answer(answer)
        
        return copy
    }
}

// MARK: - Bespoke Implementation

extension Algorithm {
    // MARK: Public Instance Interface
    
    public var numberOfComparisonsInWorstCase: NumberOfComparisons {
        Self.calculateNumberOfComparisonsInWorstCase(for: input.count)
    }
}
