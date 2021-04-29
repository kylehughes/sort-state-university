//
//  Comparison.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

public struct Comparison<Algorithm> where Algorithm: SortStateUniversity.Algorithm {
    public let source: Algorithm
    
    // MARK: Public Initialization
    
    
    // TODO: next idea: can comparison just take a closure and then not be codable and all that other shit
    // cause it clearly is not a real thing? it's just a view of the state of the algorithm. nice. it is still useful
    // but doesn't need to be stateful itself.
    

    public init(source: Algorithm) {
        self.source = source
    }
    
    // MARK: Public Instance Interface
    
    public var left: Algorithm.Element {
        source.peekAtElement(for: .left)!
    }
    
    public var right: Algorithm.Element {
        source.peekAtElement(for: .right)!
    }
    
    public func callAsFunction(_ answer: Answer) -> Algorithm {
        var algorithm = source
        algorithm.answer(answer)
        
        return algorithm
    }
    
    public func callAsFunction(_ bool: Bool) -> Algorithm {
        callAsFunction(Answer(from: bool))
    }
}

// MARK: - Codable Extension

extension Comparison: Codable where Algorithm: Codable, Algorithm.Element: Codable {
    // NO-OP
}

// MARK: - Equatable Extension

extension Comparison: Equatable where Algorithm: Equatable,  Algorithm.Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension Comparison: Hashable where Algorithm: Hashable,  Algorithm.Element: Hashable {
    // NO-OP
}

// MARK: - Identifiable Extension

extension Comparison: Identifiable where Algorithm: Hashable, Algorithm.Element: Hashable {
    // MARK: Public Instance Interface
    
    public var id: Self {
        self
    }
}

// MARK: - Extension where Algorithm.Element is Comparable

extension Comparison where Algorithm.Element: Comparable {
    // MARK: Public Instance Interface
    
    public func callAsFunction() -> Algorithm {
        self(left < right)
    }
}

// MARK: - Comparison.Answer Definition

extension Comparison {
    public enum Answer: Int, Codable, Equatable, Hashable {
        case left = 0
        case right = 1
        
        // MARK: Public Initialization
        
        public init(from bool: Bool) {
            self = bool ? .left : .right
        }
    }
}
