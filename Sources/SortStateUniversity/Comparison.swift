//
//  Comparison.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

public struct Comparison<Algorithm> where Algorithm: SortStateUniversity.Algorithm {
    public let left: Algorithm.Element
    public let right: Algorithm.Element
    public let source: Algorithm
    
    // MARK: Public Initialization

    public init(source: Algorithm, left: Algorithm.Element, right: Algorithm.Element) {
        self.source = source
        self.left = left
        self.right = right
    }
    
    // MARK: Internal Instance Interface
    
    public func callAsFunction(_ answer: Answer) -> Algorithm {
        switch answer {
        case .left:
            var algorithm = source
            algorithm.iterateForAnswer(.left, element: left)
            return algorithm
        case .right:
            var algorithm = source
            algorithm.iterateForAnswer(.right, element: right)
            return algorithm
        }
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

// MARK: - Comparison.Side Definition

extension Comparison {
    public struct Side {
        public let element: Algorithm.Element
        public let outcome: Algorithm
        
        // MARK: Public Initialization
        
        public init(element: Algorithm.Element, outcomeProvider: (Algorithm.Element) -> Algorithm) {
            self.init(element: element, outcome: outcomeProvider(element))
        }
        
        public init(element: Algorithm.Element, outcome: Algorithm) {
            self.element = element
            self.outcome = outcome
        }
    }
}

// MARK: - Codable Extension

extension Comparison.Side: Codable where Algorithm: Codable, Algorithm.Element: Codable {
    // NO-OP
}

// MARK: - Equatable Extension

extension Comparison.Side: Equatable where Algorithm: Equatable, Algorithm.Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension Comparison.Side: Hashable where Algorithm: Hashable, Algorithm.Element: Hashable {
    // NO-OP
}

// MARK: - Identifiable Extension

extension Comparison.Side: Identifiable where Algorithm: Hashable, Algorithm.Element: Hashable {
    // MARK: Public Instance Interface
    
    public var id: Self {
        self
    }
}
