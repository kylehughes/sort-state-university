//
//  Merge.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

public struct Merge<Element>: Identifiable {
    public typealias ElementProvider = (Elements.Index) -> Element
    public typealias Elements = Array<Element>
    
    public let elementProvider: ElementProvider
    public let fromIndex: Elements.Index
    public let id: UUID
    public let middleIndex: Elements.Index
    public let toIndex: Elements.Index
    
    public private(set) var leftPartitionIndex: Elements.Index
    public private(set) var output: Output
    public private(set) var outputIndex: Elements.Index
    public private(set) var rightPartitionIndex: Elements.Index
    
    // MARK: Public Initialization
    
    public init(
        fromIndex: Elements.Index,
        middleIndex: Elements.Index,
        toIndex: Elements.Index,
        input: Elements
    ) {
        self.init(fromIndex: fromIndex, middleIndex: middleIndex, toIndex: toIndex) {
            input[$0]
        }
    }
    
    public init(
        fromIndex: Elements.Index,
        middleIndex: Elements.Index,
        toIndex: Elements.Index,
        elementProvider: @escaping ElementProvider
    ) {
        self.fromIndex = fromIndex
        self.middleIndex = middleIndex
        self.toIndex = toIndex
        self.elementProvider = elementProvider
        
        id = UUID()
        leftPartitionIndex = fromIndex
        output = []
        outputIndex = fromIndex
        rightPartitionIndex = middleIndex + 1
    }
    
    // MARK: Public Instance Interface
    
    public var arePartitionIndicesInBounds: Bool {
        leftPartitionIndex <= middleIndex && rightPartitionIndex <= toIndex
    }
    
    public func getElement(for answer: Comparison<Self>.Answer) -> Element {
        switch answer {
        case .left:
            return elementProvider(leftPartitionIndex)
        case .right:
            return elementProvider(rightPartitionIndex)
        }
    }
    
    // MARK: Private Instance Interface
    
    private mutating func flushLeftPartition() {
        while leftPartitionIndex <= middleIndex {
            output.append(Transaction(inputIndex: leftPartitionIndex, outputIndex: outputIndex))
            leftPartitionIndex += 1
            outputIndex += 1
        }
    }
}

// MARK: - Algorithm Extension

extension Merge: Algorithm {
    public typealias Output = [Transaction]
    
    // MARK: Public Static Interface
    
    public static var complexity: Complexity {
        .linear
    }
    
    // MARK: Public Instance Interface

    public mutating func callAsFunction() -> AlgorithmStep<Self> {
        guard arePartitionIndicesInBounds else {
            flushLeftPartition()
            
            return .finished(output)
        }

        return .comparison(
            Comparison(source: self, elementProvider: getElement)
        )
    }
    
    public mutating func answer(_ answer: Comparison<Self>.Answer) {
        switch answer {
        case .left:
            output.append(Transaction(inputIndex: leftPartitionIndex, outputIndex: outputIndex))
            leftPartitionIndex += 1
        case .right:
            output.append(Transaction(inputIndex: rightPartitionIndex, outputIndex: outputIndex))
            rightPartitionIndex += 1
        }
        
        outputIndex += 1
    }
    
    public func peekAtElement(for answer: Comparison<Merge<Element>>.Answer) -> Element? {
        switch answer {
        case .left:
            return elementProvider(leftPartitionIndex)
        case .right:
            return elementProvider(rightPartitionIndex)
        }
    }
}

// MARK: - Merge.Transaction Definition

extension Merge {
    public struct Transaction {
        public let inputIndex: Elements.Index
        public let outputIndex: Elements.Index
        
        // MARK: Public Initialization
        
        public init(inputIndex: Elements.Index, outputIndex: Elements.Index) {
            self.inputIndex = inputIndex
            self.outputIndex = outputIndex
        }
    }
}
