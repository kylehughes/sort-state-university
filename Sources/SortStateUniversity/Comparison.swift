//
//  Comparison.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

/// A decision about the inherent order of two elements being sorted by an algorithm.
///
/// A comparison presents two elements – left and right – whose order needs to be determined, accepts an answer for that
/// decision, and produces the next state of the algorithm.
///
/// The inherent order of the elements is left to the caller. Whether an element is on the left or right is irrelevant.
/// A comparison could be used to represent "greater than," "less than," "better than," "worse than," "talller than,"
/// etc. As long as the answers to the comparisons are consistent the sorted outcome will reflect the intended order.
///
/// A comparison is technically a lense over an algorithm. It has no bespoke state itself.
public struct Comparison<Algorithm> where Algorithm: SortStateUniversity.SortingAlgorithm {
    private let source: Algorithm

    // MARK: Internal Initialization

    internal init(source: Algorithm) {
        self.source = source
    }
    
    // MARK: Public Instance Interface
    
    /// The left element in the comparison.
    ///
    /// Corresponds to `Answer.left`.
    public var left: Algorithm.Element {
        source.peekAtElementUnsafely(for: .left)
    }
    
    /// The right element in the comparison.
    ///
    /// Corresponds to `Answer.right`.
    public var right: Algorithm.Element {
        source.peekAtElementUnsafely(for: .right)
    }
    
    /// Accesses the element for the specified side.
    ///
    /// - Parameter side: The side whose element will be accessed.
    /// - Returns: The element for the specified side.
    public subscript(side: Side) -> Algorithm.Element {
        source.peekAtElementUnsafely(for: side)
    }
    
    /// Answers the comparison with the given side.
    ///
    /// The given side "wins" the comparison. What "winning" means is left to the caller, but it is important that
    /// the same criteria is applied to all elements consistently.
    ///
    /// The returned algorithm will be the algorithm at its next state, after the comparison is made. The algorithm
    /// can be executed to continue producing comparisons and eventually the sorted output.
    ///
    /// - Parameter answer: The side that wins the comparison.
    /// - Returns: The state of the algorithm after the comparison.
    public func callAsFunction(_ answer: Side) -> Algorithm {
        source.answering(answer)
    }
    
    /// Answers the comparison with whether or not the left side won.
    ///
    /// The returned algorithm will be the algorithm at its next state, after the comparison is made. The algorithm
    /// can be executed to continue producing comparisons and eventually the sorted output.
    ///
    /// This function is provided for convenience when there is already a Boolean value that can be used for the
    /// comparison. Otherwise, `callAsFunction(_ answer: Side)` should be preferred for readability.
    public func callAsFunction(_ bool: Bool) -> Algorithm {
        callAsFunction(bool ? .left : .right)
    }
}

// MARK: - Extension where Algorithm.Element is Comparable

extension Comparison where Algorithm.Element: Comparable {
    // MARK: Public Instance Interface
    
    /// Answers the comparison with whether or not the left side is less than the right side.
    ///
    /// The returned algorithm will be the algorithm at its next state, after the comparison is made. The algorithm
    /// can be executed to continue producing comparisons and eventually the sorted output.
    public func callAsFunction() -> Algorithm {
        self(left < right)
    }
}

// MARK: - Codable Extension

extension Comparison: Codable where Algorithm: Codable {
    // NO-OP
}

// MARK: - Equatable Extension

extension Comparison: Equatable where Algorithm: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension Comparison: Hashable where Algorithm: Hashable {
    // NO-OP
}

// MARK: - Comparison.Side Definition

extension Comparison {
    /// A relative direction in a comparison.
    ///
    /// - SeeAlso: https://en.wikipedia.org/wiki/Body_relative_direction
    public enum Side: Equatable, Hashable {
        /// The left side of the comparison.
        case left
        
        /// The right side of the comparison.
        case right
    }
}
