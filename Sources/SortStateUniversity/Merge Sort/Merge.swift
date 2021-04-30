//
//  Merge.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

extension MergeSort {
    public struct Merge: Codable, Equatable {
        public let constraints: Constraints
        
        public private(set) var leftPartitionIndex: MergeSort.Elements.Index
        public private(set) var output: Set<Transaction>
        public private(set) var outputIndex: MergeSort.Elements.Index
        public private(set) var rightPartitionIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        public init(
            fromIndex: MergeSort.Elements.Index,
            middleIndex: MergeSort.Elements.Index,
            toIndex: MergeSort.Elements.Index
        ) {
            self.init(constraints: Constraints(fromIndex: fromIndex, middleIndex: middleIndex, toIndex: toIndex))
        }
        
        public init(constraints: Constraints) {
            self.constraints = constraints
            
            leftPartitionIndex = constraints.fromIndex
            output = []
            outputIndex = constraints.fromIndex
            rightPartitionIndex = constraints.middleIndex + 1
        }
        
        // MARK: Public Instance Interface
        
        public var arePartitionIndicesInBounds: Bool {
            leftPartitionIndex <= constraints.middleIndex && rightPartitionIndex <= constraints.toIndex
        }
        
        public var leftTransaction: Transaction {
            Transaction(inputIndex: leftPartitionIndex, outputIndex: outputIndex)
        }
        
        public var rightTransaction: Transaction {
            Transaction(inputIndex: rightPartitionIndex, outputIndex: outputIndex)
        }
        
        public mutating func answer(_ answer: Comparison<MergeSort>.Answer) {
            switch answer {
            case .left:
                output.insert(leftTransaction)
                leftPartitionIndex += 1
            case .right:
                output.insert(rightTransaction)
                rightPartitionIndex += 1
            }
            
            outputIndex += 1
        }
        
        public mutating func callAsFunction() -> Set<Transaction>? {
            guard arePartitionIndicesInBounds else {
                flushLeftPartition()
                
                return output
            }

            return nil
        }
        
        // MARK: Private Instance Interface
        
        private mutating func flushLeftPartition() {
            while leftPartitionIndex <= constraints.middleIndex {
                output.insert(leftTransaction)
                leftPartitionIndex += 1
                outputIndex += 1
            }
        }
    }
}

extension MergeSort.Merge: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(leftPartitionIndex)
//        hasher.combine(output)
//        hasher.combine(outputIndex)
        hasher.combine(rightPartitionIndex)
    }
}

// MARK: - Merge.Constraints Definition

extension MergeSort.Merge {
    public struct Constraints: Codable, Equatable, Hashable {
        public let fromIndex: MergeSort.Elements.Index
        public let middleIndex: MergeSort.Elements.Index
        public let toIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        public init(
            fromIndex: MergeSort.Elements.Index,
            middleIndex: MergeSort.Elements.Index,
            toIndex: MergeSort.Elements.Index
        ) {
            self.fromIndex = fromIndex
            self.middleIndex = middleIndex
            self.toIndex = toIndex
        }
    }
}

// MARK: - Merge.Transaction Definition

extension MergeSort.Merge {
    public struct Transaction: Codable, Equatable, Hashable {
        public let inputIndex: MergeSort.Elements.Index
        public let outputIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        public init(inputIndex: MergeSort.Elements.Index, outputIndex: MergeSort.Elements.Index) {
            self.inputIndex = inputIndex
            self.outputIndex = outputIndex
        }
    }
}
