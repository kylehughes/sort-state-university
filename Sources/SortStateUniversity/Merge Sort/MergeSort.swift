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
    
    public private(set) var currentIndex: Elements.Index
    public private(set) var ongoingMerge: Merge<Element>?
    public private(set) var output: Elements
    public private(set) var partitionSize: Int
    
    // MARK: Public Initialization
    
    public init(input: Elements) {
        self.input = input
        
        currentIndex = input.startIndex
        id = UUID()
        ongoingMerge = nil
        output = input
        partitionSize = 1
    }
    
    // MARK: Private Instance Interface
    
    private func finish() -> AlgorithmStep<Self>? {
        guard partitionSize < input.endIndex else {
            return .finished(output)
        }
        
        return nil
    }
    
    private mutating func iterateCursorLoop() -> AlgorithmStep<Self> {
        let fromIndex = currentIndex
        let middleIndex = fromIndex + partitionSize - 1
        let toIndex = min(fromIndex + (2 * partitionSize) - 1, input.endIndex - 1)
        
        ongoingMerge = Merge(fromIndex: fromIndex, middleIndex: middleIndex, toIndex: toIndex, input: output)
        
        return self()
    }
    
    private mutating func iterateMerge() -> AlgorithmStep<Self>? {
        guard ongoingMerge != nil else {
            return nil
        }

        switch ongoingMerge!() {
        case .comparison:
            return .comparison(Comparison(source: self))
        case let .finished(mergeOutput):
            currentIndex += 2 * partitionSize
            let mergeInput = output
            for transaction in mergeOutput {
                output[transaction.outputIndex] = mergeInput[transaction.inputIndex]
            }
            ongoingMerge = nil
            return nil
        }
    }
    
    private mutating func iteratePartitionLoop() -> AlgorithmStep<Self>? {
        guard currentIndex < input.endIndex - partitionSize else {
            currentIndex = output.startIndex
            partitionSize *= 2
            
            return self()
        }
        
        return nil
    }
}

// MARK: - Algorithm Extension

extension MergeSort: Algorithm {
    // MARK: Public Typealiases
    
    public typealias Output = Elements
    
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
            ongoingMerge?.answer(.left)
        case .right:
            ongoingMerge?.answer(.right)
        }
    }
    
    public func peekAtElement(for answer: Comparison<MergeSort<Element>>.Answer) -> Element {
        switch answer {
        case .left:
            return ongoingMerge!.peekAtElement(for: .left)
        case .right:
            return ongoingMerge!.peekAtElement(for: .right)
        }
    }
}
