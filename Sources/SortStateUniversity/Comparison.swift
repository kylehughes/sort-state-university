//
//  Comparison.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

public struct Comparison<Algorithm> where Algorithm: SortStateUniversity.Algorithm {
    public typealias ElementProvider = (Answer) -> Algorithm.Element
    public typealias NextAlgorithmProvider = (Answer) -> Algorithm
    
    public let elementProvider: ElementProvider
    public let nextAlgorithmProvider: NextAlgorithmProvider
    
    // MARK: Public Initialization
    
    public init(source: Algorithm) {
        self.init(
            nextAlgorithmProvider: source.answering,
            elementProvider: source.peekAtElement
        )
    }

    public init(nextAlgorithmProvider: @escaping NextAlgorithmProvider, elementProvider: @escaping ElementProvider) {
        self.nextAlgorithmProvider = nextAlgorithmProvider
        self.elementProvider = elementProvider
    }
    
    // MARK: Public Instance Interface
    
    public var left: Algorithm.Element {
        elementProvider(.left)
    }
    
    public var right: Algorithm.Element {
        elementProvider(.right)
    }
    
    public func callAsFunction(_ answer: Answer) -> Algorithm {
        nextAlgorithmProvider(answer)
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
