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
    internal typealias ElementProvider = (Side) -> Algorithm.Element
    internal typealias NextAlgorithmProvider = (Side) -> Algorithm
    
    private let elementProvider: ElementProvider
    private let nextAlgorithmProvider: NextAlgorithmProvider

    // MARK: Internal Initialization
    
    internal init(nextAlgorithmProvider: @escaping NextAlgorithmProvider, elementProvider: @escaping ElementProvider) {
        self.nextAlgorithmProvider = nextAlgorithmProvider
        self.elementProvider = elementProvider
    }
    
    internal init(source: Algorithm) {
        self.init(nextAlgorithmProvider: source.answering, elementProvider: source.peekAtElementUnsafely)
    }
    
    // MARK: Public Instance Interface
    
    /// The left element in the comparison.
    ///
    /// Corresponds to `Answer.left`.
    public var left: Algorithm.Element {
        elementProvider(.left)
    }
    
    /// The right element in the comparison.
    ///
    /// Corresponds to `Answer.right`.
    public var right: Algorithm.Element {
        elementProvider(.right)
    }
    
    /// Accesses the element for the specified side.
    ///
    /// - Parameter side: The side whose element will be accessed.
    /// - Returns: The element for the specified side.
    public subscript(side: Side) -> Algorithm.Element {
        elementProvider(side)
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
        nextAlgorithmProvider(answer)
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
