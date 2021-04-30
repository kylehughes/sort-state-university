//
//  Merge.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

public struct Merge<Element>: Identifiable {
    public typealias Elements = Array<Element>
    public typealias InputProvider = () -> Elements
    
    public let fromIndex: Elements.Index
    public let id: UUID
    public let inputProvider: InputProvider
    public let middleIndex: Elements.Index
    public let toIndex: Elements.Index
    
    public private(set) var leftPartitionIndex: Elements.Index
    public private(set) var output: Elements
    public private(set) var outputIndex: Elements.Index
    public private(set) var rightPartitionIndex: Elements.Index
    
    // MARK: Public Initialization
    
    public init(
        fromIndex: Elements.Index,
        middleIndex: Elements.Index,
        toIndex: Elements.Index,
        inputProvider: @escaping InputProvider
    ) {
        self.fromIndex = fromIndex
        self.middleIndex = middleIndex
        self.toIndex = toIndex
        self.inputProvider = inputProvider
        
        id = UUID()
        leftPartitionIndex = fromIndex
        output = inputProvider()
        outputIndex = fromIndex
        rightPartitionIndex = middleIndex + 1
    }
    
    // MARK: Public Instance Interface
    
    public var arePartitionIndicesInBounds: Bool {
        leftPartitionIndex <= middleIndex && rightPartitionIndex <= toIndex
    }
    
    // MARK: Private Instance Interface
    
    private mutating func flushLeftPartition() {
        while leftPartitionIndex <= middleIndex {
            output[outputIndex] = inputProvider()[leftPartitionIndex]
            leftPartitionIndex += 1
            outputIndex += 1
        }
    }
}

// MARK: - Algorithm Extension

extension Merge: Algorithm {
    public var input: [Element] {
        inputProvider()
    }
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
        
        return .comparison(Comparison(source: self))
    }
    
    public mutating func answer(_ answer: Comparison<Self>.Answer) {
        switch answer {
        case .left:
            output[outputIndex] = inputProvider()[leftPartitionIndex]
            leftPartitionIndex += 1
        case .right:
            output[outputIndex] = inputProvider()[rightPartitionIndex]
            rightPartitionIndex += 1
        }
        
        outputIndex += 1
    }
    
    public func peekAtElement(for answer: Comparison<Merge<Element>>.Answer) -> Element? {
        switch answer {
        case .left:
            return inputProvider()[leftPartitionIndex]
        case .right:
            return inputProvider()[rightPartitionIndex]
        }
    }
}
