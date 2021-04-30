//
//  MergeSort.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

/// An iterative, stateful implementation of merge sort.
public struct MergeSort<Element>: Identifiable {
    public typealias Elements = Array<Element>
    
    public let id: UUID
    public let input: Elements
    
    public private(set) var variables: Variables
    
    // MARK: Public Initialization
    
    public init(input: Elements) {
        self.input = input
        
        id = UUID()
        variables = Variables(input: input)
    }
    
    // MARK: Private Instance Interface
    
    private func finish() -> AlgorithmStep<Self>? {
        guard variables.partitionSize < input.endIndex else {
            return .finished(variables.output)
        }
        
        return nil
    }
    
    private mutating func iterateCursorLoop() -> AlgorithmStep<Self> {
        let fromIndex = variables.currentIndex
        let middleIndex = fromIndex + variables.partitionSize - 1
        let toIndex = min(fromIndex + (2 * variables.partitionSize) - 1, input.endIndex - 1)
        
        variables.ongoingMerge = Merge(fromIndex: fromIndex, middleIndex: middleIndex, toIndex: toIndex)
        
        return self()
    }
    
    private mutating func iterateMerge() -> AlgorithmStep<Self>? {
        guard variables.ongoingMerge != nil else {
            return nil
        }
        
        guard let transactions = variables.ongoingMerge!() else {
            return .comparison(Comparison(source: self))
        }
        
        perform(transactions)
        variables.currentIndex += 2 * variables.partitionSize
        variables.ongoingMerge = nil
        
        return nil
    }
    
    private mutating func iteratePartitionLoop() -> AlgorithmStep<Self>? {
        guard variables.currentIndex < input.endIndex - variables.partitionSize else {
            variables.currentIndex = variables.output.startIndex
            variables.partitionSize *= 2
            
            return self()
        }
        
        return nil
    }
    
    private mutating func perform(_ transactions: Set<Merge.Transaction>) {
        let input = variables.output
        
        for transaction in transactions {
            variables.output[transaction.outputIndex] = input[transaction.inputIndex]
        }
    }
}

// MARK: - Algorithm Extension

extension MergeSort: Algorithm {
    // MARK: Public Static Interface
    
    public static var complexity: Complexity {
        .linearithmic
    }
    
    public static func calculateNumberOfComparisonsInWorstCase(for n: Int) -> NumberOfComparisons {
        switch n {
        case 0:
            return .exact(0)
        case 1:
            return .exact(0)
        case 2:
            return .exact(1)
        case 3:
            return .exact(3)
        case 4:
            return .exact(5)
        case 5:
            return .exact(9)
        default:
            return .ceiling(for: n, using: complexity)
        }
    }
    
    // MARK: Public Instance Interface
    
    public mutating func callAsFunction() -> AlgorithmStep<Self> {
        finish() ?? iterateMerge() ?? iteratePartitionLoop() ?? iterateCursorLoop()
    }
    
    public mutating func answer(_ answer: Comparison<Self>.Answer) {
        switch answer {
        case .left:
            variables.ongoingMerge?.answer(.left)
        case .right:
            variables.ongoingMerge?.answer(.right)
        }
    }
    
    public func peekAtElement(for answer: Comparison<MergeSort<Element>>.Answer) -> Element? {
        guard let ongoingMerge = variables.ongoingMerge else {
            return nil
        }
        
        switch answer {
        case .left:
            return variables.output[ongoingMerge.leftPartitionIndex]
        case .right:
            return variables.output[ongoingMerge.rightPartitionIndex]
        }
    }
}

// MARK: - Variables Definition

extension MergeSort {
    public struct Variables {
        public var currentIndex: Elements.Index
        public var ongoingMerge: Merge?
        public var output: Elements
        public var partitionSize: Int
        
        // MARK: Public Initialization
        
        public init(input: Elements) {
            currentIndex = input.startIndex
            ongoingMerge = nil
            output = input
            partitionSize = 1
        }
    }
}

extension MergeSort.Variables: Equatable where Element: Equatable {
    
}

extension MergeSort.Variables: Hashable where Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(currentIndex)
        hasher.combine(ongoingMerge)
        hasher.combine(partitionSize)
    }
}
