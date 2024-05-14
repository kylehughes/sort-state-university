//
//  SortingAlgorithmStep.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/19/21.
//

/// A step in a sorting algorithm.
///
/// This is the primary way that a sorting algorithm communicates with a caller. This is not a step in the literal sense
/// of how a given sorting algorithm is implemented; this is a step as visible to the caller. A sorting algorithm may
/// perform many operations internally but the caller will only ever see the comparisons. To the caller, a sorting
/// algorithm is a sequence of steps: many comparisons followed by a terminal output.
///
/// A sorting algorithm will return a step when executed (i.e. `SortingAlgorithm.callAsFunction()`). The step informs
/// the caller of the current state of the algorithm and what is next required from the caller. If the step is of case
/// `comparison` then the algorithm requires an answer to the comparison in order to continue. If the step is of case
/// `finished` then the algorithm is finished and the sorted output is provided.
///
/// In an abstract sense, a step is a node in tree of possible paths that a sorting algorithm can take.
public enum SortingAlgorithmStep<Algorithm> where Algorithm: SortStateUniversity.SortingAlgorithm {
    /// The sorting algorithm is running.
    ///
    /// The current comparison that needs to be answered is included. Answering the comparison will provide the next
    /// state of the sorting algorithm which can provide the next step.
    ///
    /// This is not a terminal step.
    case comparison(Comparison<Algorithm>)
    
    /// The sorting algorithm is finished.
    ///
    /// The sorted output is included.
    ///
    /// This is a terminal step.
    case finished([Algorithm.Element])
    
    // MARK: Public Instance Interface
    
    /// The comparison at this step in the sorting algorithm, if available.
    ///
    /// If the step is of case `comparison` then this value will be the comparison at this step in the sorting
    /// algorithm, otherwise this value will be `nil`.
    @inlinable
    public var comparison: Comparison<Algorithm>? {
        guard case let .comparison(comparison) = self else {
            return nil
        }
        
        return comparison
    }
    
    /// A Boolean value indicating whether the step is of case `comparison`.
    @inlinable
    public var isComparison: Bool {
        guard case .comparison = self else {
            return false
        }
        
        return true
    }
    
    /// A Boolean value indicating whether the step is of case `finished`.
    @inlinable
    public var isFinished: Bool {
        guard case .finished = self else {
            return false
        }
        
        return true
    }
    
    /// A Boolean value indicating whether the step is not of case `comparison`.
    @inlinable
    public var isNotComparison: Bool {
        guard case .comparison = self else {
            return true
        }
        
        return false
    }
    
    /// A Boolean value indicating whether the step is not of case `finished`.
    @inlinable
    public var isNotFinished: Bool {
        guard case .finished = self else {
            return true
        }
        
        return false
    }
    
    /// The output from the sorting algorithm, if available.
    ///
    /// If the step is of case `finished` then this value will be the output of the sorting algorithm, otherwise this
    /// value will be `nil`.
    @inlinable
    public var output: [Algorithm.Element]? {
        guard case let .finished(output) = self else {
            return nil
        }
        
        return output
    }
}

// MARK: - Codable Extension

extension SortingAlgorithmStep: Codable where Algorithm: Codable, Algorithm.Element: Codable {
    // NO-OP
}

// MARK: - Equatable Extension

extension SortingAlgorithmStep: Equatable where Algorithm: Equatable, Algorithm.Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension SortingAlgorithmStep: Hashable where Algorithm: Hashable, Algorithm.Element: Hashable {
    // NO-OP
}
