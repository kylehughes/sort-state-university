//
//  AlgorithmStep.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/19/21.
//

public enum AlgorithmStep<Algorithm> where Algorithm: SortStateUniversity.Algorithm {
    case comparison(Comparison<Algorithm>)
    case finished(Algorithm.Output)
    
    // MARK: Public Instance Interface
    
    public var comparison: Comparison<Algorithm>? {
        guard case let .comparison(comparison) = self else {
            return nil
        }
        
        return comparison
    }
    
    public var isComparison: Bool {
        guard case .comparison = self else {
            return false
        }
        
        return true
    }
    
    public var isFinished: Bool {
        guard case .finished = self else {
            return false
        }
        
        return true
    }
    
    public var isNotComparison: Bool {
        guard case .comparison = self else {
            return true
        }
        
        return false
    }
    
    public var isNotFinished: Bool {
        guard case .finished = self else {
            return true
        }
        
        return false
    }
    
    public var output: Algorithm.Output? {
        guard case let .finished(output) = self else {
            return nil
        }
        
        return output
    }
}
