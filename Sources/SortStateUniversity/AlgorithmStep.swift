//
//  AlgorithmStep.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/19/21.
//

public enum AlgorithmStep<Algorithm> where Algorithm: SortStateUniversity.Algorithm {
    case comparison(Comparison<Algorithm>)
    case finished([Algorithm.Element])
    
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
    
    public var output: [Algorithm.Element]? {
        guard case let .finished(output) = self else {
            return nil
        }
        
        return output
    }
}

// MARK: - Equatable Extension

extension AlgorithmStep: Equatable where Algorithm: Equatable, Algorithm.Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension AlgorithmStep: Hashable where Algorithm: Hashable, Algorithm.Element: Hashable {
    // NO-OP
}

// MARK: - Identifiable Extension

extension AlgorithmStep: Identifiable where Algorithm: Hashable, Algorithm.Element: Hashable {
    // Public Instance Interface
    
    public var id: Self {
        self
    }
}
