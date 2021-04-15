//
//  Merge.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

public struct Merge<Element>: Identifiable {
    public typealias Elements = Array<Element>
    
    public let fromIndex: Elements.Index
    public let id: UUID
    public let input: Elements
    public let middleIndex: Elements.Index
    public let toIndex: Elements.Index
    
    public private(set) var leftPartitionIndex: Elements.Index
    public private(set) var output: Elements
    public private(set) var outputIndex: Elements.Index
    public private(set) var rightPartitionIndex: Elements.Index
    
    // MARK: Public Initialization
    
    public init(input: Elements, fromIndex: Elements.Index, middleIndex: Elements.Index, toIndex: Elements.Index) {
        self.input = input
        self.fromIndex = fromIndex
        self.middleIndex = middleIndex
        self.toIndex = toIndex
        
        id = UUID()
        leftPartitionIndex = fromIndex
        output = input
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
            output[outputIndex] = input[leftPartitionIndex]
            leftPartitionIndex += 1
            outputIndex += 1
        }
    }
    
    private func makeComparison() -> Comparison<Self> {
        Comparison(
            leftSide: Comparison.Side(
                element: input[leftPartitionIndex]
            ) {
                var algorithm = self
                algorithm.output[outputIndex] = $0
                algorithm.outputIndex += 1
                algorithm.leftPartitionIndex += 1
                return algorithm
            },
            rightSide: Comparison.Side(
                element: input[rightPartitionIndex]
            ) {
                var algorithm = self
                algorithm.output[outputIndex] = $0
                algorithm.outputIndex += 1
                algorithm.rightPartitionIndex += 1
                return algorithm
            }
        )
    }
}

// MARK: - Algorithm Extension

extension Merge: Algorithm {
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
        
        return .comparison(makeComparison())
    }
}

// MARK: - Codable Extension

extension Merge: Codable where Element: Codable {
    // NO-OP
}

// MARK: - Equatable Extension

extension Merge: Equatable where Element: Equatable {
    // NO-OP
}

// MARK: - Hashable Extension

extension Merge: Hashable where Element: Hashable {
    // NO-OP
}
