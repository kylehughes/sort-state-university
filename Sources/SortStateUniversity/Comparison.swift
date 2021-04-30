//
//  Comparison.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

public struct Comparison<Algorithm> where Algorithm: SortStateUniversity.Algorithm {
    public typealias SourceProvider = () -> Algorithm
    
    public let sourceProvider: SourceProvider
    
    // MARK: Public Initialization
    
    public init(source: Algorithm) {
        self.init {
            source
        }
    }

    public init(sourceProvider: @escaping SourceProvider) {
        self.sourceProvider = sourceProvider
    }
    
    // MARK: Public Instance Interface
    
    public var left: Algorithm.Element {
        sourceProvider().peekAtElement(for: .left)!
    }
    
    public var right: Algorithm.Element {
        sourceProvider().peekAtElement(for: .right)!
    }
    
    public func callAsFunction(_ answer: Answer) -> Algorithm {
        var algorithm = sourceProvider()
        algorithm.answer(answer)
        
        return algorithm
    }
    
    public func callAsFunction(_ bool: Bool) -> Algorithm {
        callAsFunction(Answer(from: bool))
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
    public enum Answer: Equatable, Hashable {
        case left
        case right
        
        // MARK: Public Initialization
        
        public init(from bool: Bool) {
            self = bool ? .left : .right
        }
    }
}
