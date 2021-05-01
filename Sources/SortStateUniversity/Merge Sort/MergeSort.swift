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
    public private(set) var ongoingMerge: Merge?
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
        
        ongoingMerge = Merge(fromIndex: fromIndex, middleIndex: middleIndex, toIndex: toIndex)
        
        return self()
    }
    
    private mutating func iterateMerge() -> AlgorithmStep<Self>? {
        guard ongoingMerge != nil else {
            return nil
        }
        
        guard let transactions = ongoingMerge!() else {
            return .comparison(Comparison(source: self))
        }
        
        perform(transactions)
        currentIndex += 2 * partitionSize
        ongoingMerge = nil
        
        return nil
    }
    
    private mutating func iteratePartitionLoop() -> AlgorithmStep<Self>? {
        guard currentIndex < input.endIndex - partitionSize else {
            currentIndex = output.startIndex
            partitionSize *= 2
            
            return self()
        }
        
        return nil
    }
    
    private mutating func perform(_ transactions: Set<Merge.Transaction>) {
        let input = output
        
        for transaction in transactions {
            output[transaction.outputIndex] = input[transaction.inputIndex]
        }
    }
}

// MARK: - Algorithm Extension

extension MergeSort: Algorithm {
    // MARK: Public Static Interface
    
    public static var complexity: Complexity {
        .linearithmic
    }
    
    public static func calculateMaximumNumberOfComparisonsInWorstCase(for n: Int) -> Int {
        /// This is a Swift port of the algorithm from D. E. Knuth, Art of Computer Programming, Vol. 3,
        /// Sections 5.2.4., Problem 14. (https://oeis.org/A003071)
        
        let exponents = n.exponentsForDecomposedPowersOfTwo
        
        guard let lastExponent = exponents.last else {
            return 0
        }
        
        var sum = 0
        
        for index in exponents.indices {
            let exponent = exponents[index]
            sum += (exponent + index) * 2.pow(exponent)
        }
        
        return 1 - 2.pow(lastExponent) + sum
    }
    
    // MARK: Public Instance Interface
    
    public mutating func answer(_ answer: Comparison<Self>.Answer) {
        switch answer {
        case .left:
            ongoingMerge?.answer(.left)
        case .right:
            ongoingMerge?.answer(.right)
        }
    }
    
    public mutating func callAsFunction() -> AlgorithmStep<Self> {
        finish() ?? iterateMerge() ?? iteratePartitionLoop() ?? iterateCursorLoop()
    }
    
    public func peekAtElement(for answer: Comparison<MergeSort<Element>>.Answer) -> Element? {
        guard let ongoingMerge = ongoingMerge else {
            return nil
        }
        
        switch answer {
        case .left:
            return output[ongoingMerge.leftPartitionIndex]
        case .right:
            return output[ongoingMerge.rightPartitionIndex]
        }
    }
}
