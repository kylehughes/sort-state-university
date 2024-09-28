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
        .insertionSort
    }
    
    /// Returns the average number of comparisons that insertion sort will perform given an input with `n` elements.
    ///
    /// The average number of comparisons in insertion sort is calculated using the formula `E[X] = n(Hₙ - 1)`, where
    /// `Hₙ` is the nth harmonic number.
    ///
    /// This calculation is based on the following analysis:
    ///
    /// 1. **Total Comparisons Random Variable:**
    ///    - Let `X` be the random variable representing the total number of comparisons used by insertion sort.
    ///    - `X` is the sum of comparisons needed to insert each element:
    ///      ```
    ///      X = X₂ + X₃ + ... + Xₙ
    ///      ```
    ///
    /// 2. **Expected Comparisons for Each Insertion:**
    ///    - The expected number of comparisons to insert the `i`th element is:
    ///      ```
    ///      E[Xᵢ] = Hᵢ - 1
    ///      ```
    ///      where `Hᵢ` is the `i`th harmonic number.
    ///
    /// 3. **Total Expected Comparisons:**
    ///    - Summing over all elements from `i = 2` to `n`:
    ///      ```
    ///      E[X] = ∑_{i=2}^{n} (Hᵢ - 1)
    ///      ```
    ///    - This simplifies to:
    ///      ```
    ///      E[X] = n(Hₙ - 1)
    ///      ```
    ///
    /// - Note: Based on the average-case analysis of insertion sort as described in **The Art of Computer Programming**
    ///   by Donald E. Knuth, Volume 3: *Sorting and Searching*.
    /// - Parameter n: The number of elements.
    /// - Returns: The average number of comparisons that the algorithm will perform.
    @inlinable
    public static func averageNumberOfComparisons(for n: Int) -> Double {
        guard 0 < n else {
            return 0
        }

        let nDouble = Double(n)
        let harmonicNumber: Double = {
            guard n < 10000 else {
                /// We approximate the value for large values of n for the sake of performance.
                return
                    log(nDouble) +
                    .eulerMascheroni +
                    1.0 / (2.0 * nDouble) -
                    1.0 / (12.0 * nDouble * nDouble) +
                    1.0 / (120.0 * pow(nDouble, 4))
            }
            
            return (1 ... n).reduce(0) { sum, k in
                sum + 1.0 / Double(k)
            }
        }()

        return nDouble * (harmonicNumber - 1.0)
    }

    /// Returns the maximum number of comparisons that insertion sort will perform given an input with `n` elements.
    ///
    /// The algorithm may require fewer comparisons depending on the initial order of the input elements.
    ///
    /// The maximum number of comparisons in insertion sort occurs when the input array is sorted in reverse order, 
    /// which requires approximately `n²⁄2` comparisons.
    ///
    /// - Note: Based on the worst-case analysis of insertion sort as described in **Introduction to Algorithms**
    ///   by Cormen, Leiserson, Rivest, and Stein (CLRS), 3rd Edition, Section 2.1.
    /// - SeeAlso: [Introduction to Algorithms](https://mitpress.mit.edu/9780262033848/introduction-to-algorithms/)
    /// - Parameter n: The number of elements.
    /// - Returns: The maximum number of comparisons that the algorithm will perform.
    @inlinable
    public static func maximumNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }
        
        return Double(n * (n - 1) / 2)
    }

    /// Returns the minimum number of comparisons that insertion sort will perform given an input with `n` elements.
    ///
    /// The algorithm may require more comparisons depending on the initial order of the input elements.
    ///
    /// The minimum number of comparisons in insertion sort occurs when the input array is already sorted, which 
    /// requires `n - 1` comparisons.
    ///
    /// - Note: Based on the best-case analysis of insertion sort as described in **Introduction to Algorithms**
    ///   by Cormen, Leiserson, Rivest, and Stein (CLRS), 3rd Edition, Section 2.1.
    /// - SeeAlso: [Introduction to Algorithms](https://mitpress.mit.edu/9780262033848/introduction-to-algorithms/)
    /// - Parameter n: The number of elements.
    /// - Returns: The minimum number of comparisons that the algorithm will perform.
    @inlinable
    public static func minimumNumberOfComparisons(for n: Int) -> Double {
        guard 1 < n else {
            return 0
        }
        
        return Double(n - 1)
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
