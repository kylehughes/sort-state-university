//
//  Comparison.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

public struct Comparison<Algorithm> where Algorithm: SortStateUniversity.Algorithm {
    public typealias ElementProvider = (Answer) -> Algorithm.Element
    public typealias SourceProvider = () -> Algorithm
    
    public let elementProvider: ElementProvider
    public let sourceProvider: SourceProvider
    
    // MARK: Public Initialization
    
    public init(source: Algorithm, elementProvider: @escaping ElementProvider) {
        self.init(
            sourceProvider: {
                source
            },
            elementProvider: elementProvider
        )
    }

    public init(sourceProvider: @escaping SourceProvider, elementProvider: @escaping ElementProvider) {
        self.elementProvider = elementProvider
        self.sourceProvider = sourceProvider
    }
    
    // MARK: Public Instance Interface
    
    public var left: Algorithm.Element {
        elementProvider(.left)
    }
    
    public var right: Algorithm.Element {
        elementProvider(.right)
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
