//
//  SortingAlgorithm.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

/// A sorting algorithm, implemented statefully.
///
/// The algorithm is responsible for sorting `input` into `output` given the answers to the comparisons returned from
/// `callAsFunction()`.
///
/// The elements that are sorted do not need to conform to `Comparable` because the evaluation of the comparison is left
/// to the caller.
public protocol SortingAlgorithm: Identifiable {
    // MARK: Associated Types
    
    /// A type that represents the element that the algorithm is sorting.
    associatedtype Element
    
    // MARK: Static Interface
    
    /// The runtime complexity of the algorithm.
    static var complexity: Complexity { get }
    
    /// The unique label of the algorithm.
    static var label: SortingAlgorithmLabel { get }
    
    /// Returns the number of comparisons that the algorithm will perform, in the worst case, given an input
    /// with `n` elements.
    ///
    /// The algorithm may require fewer total comparisons than returned depending on the state of the input and the
    /// answers to the comparisons. The algorithm is guaranteed to not require more comparisons than returned.
    ///
    /// This value is provably correct and precise. It is not an estimate.
    ///
    /// - Parameter n: The number of elements.
    /// - Returns: The number of comparisons that the algorithm will perform in the worst case.
    static func calculateMaximumNumberOfComparisonsInWorstCase(for n: Int) -> Int
    
    // MARK: Instance Interface
    
    /// The given elements that the algorithm is sorting.
    ///
    /// This value is constant and will not change after instantiation.
    var input: [Element] { get }
    
    /// The current result of applying the sorting algorithm to `input`.
    ///
    /// This value is "live" and will change as the algorithm is executed. When the algorithm is finished this value
    /// will contain the sorted result of `input`. It is primarily exposed to allow the internals of the algorithm to
    /// be observed.
    ///
    /// This value should not be used as the final output of the algorithm unless it is known that the algorithm has
    /// finished. It may be easier to perform `callAsFunction()` and respond to the step that is returned – the output
    /// will be reported through that function if the algorithm is finished.
    var output: [Element] { get }
    
    /// Answers the current comparison with the given side.
    ///
    /// The algorithm is advanced to the state that follows the answer.
    ///
    /// If the algorithm is not at a point of comparison then this function will have no effect.
    ///
    /// - Parameter answer: The answer to the current comparison.
    mutating func answer(_ answer: Comparison<Self>.Side)
    
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
    mutating func callAsFunction() -> SortingAlgorithmStep<Self>
    
    /// Returns the element that represents the given side of the current comparison.
    ///
    /// If the algorithm is not at a point of comparison then `nil` will be returned. For example, if the
    /// algorithm has not started or is finished then `nil` will be returned.
    ///
    /// - Parameter answer: The answer that represents the side of the comparison to peek at.
    /// - Returns: The element that represents the given side of the current comparison, or `nil` if the algorithm
    ///   is not at a point of comparison.
    func peekAtElement(for answer: Comparison<Self>.Side) -> Element?
}

// MARK: - Implementation

extension SortingAlgorithm {
    // MARK: Public Instance Interface
    
    /// The number of comparisons that the algorithm will perform in the worst case.
    ///
    /// The algorithm may require fewer total comparisons than returned depending on the state of the input and the
    /// answers to the comparisons. The algorithm is guaranteed to not require more comparisons than returned.
    public var numberOfComparisonsInWorstCase: Int {
        Self.calculateMaximumNumberOfComparisonsInWorstCase(for: input.count)
    }
    
    /// Returns the current algorithm after answering the current comparison with the given answer.
    ///
    /// The algorithm is advanced to the state that follows the answer.
    ///
    /// If the algorithm is not at a point of comparison then this function will return itself.
    ///
    /// - Parameter answer: The answer to the current comparison.
    /// - Returns: The algorithm after applying the answer to the current comparison.
    public func answering(_ answer: Comparison<Self>.Side) -> Self {
        var copy = self
        copy.answer(answer)
        
        return copy
    }
    
    // MARK: Internal Instance Interface
    
    /// Returns the element that represents the given side of the current comparison.
    ///
    /// The algorithm is assumed to be at a point of comparison – the value from `peekAtElement(for:)` is forcefully
    /// unwrapped. Do not use this if it is possible that there is no element available for peeking at.
    ///
    /// This is useful for passing a function reference to a parameter that expects a non-`Optional` return type.
    ///
    /// - Precondition: The algorithm is at a point of comparison.
    /// - Parameter answer: The answer that represents the side of the comparison to peek at.
    /// - Returns: The element that represents the given side of the current comparison.
    internal func peekAtElementUnsafely(for answer: Comparison<Self>.Side) -> Element {
        peekAtElement(for: answer)!
    }
}
