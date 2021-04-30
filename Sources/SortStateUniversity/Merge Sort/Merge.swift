//
//  Merge.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

extension MergeSort {
    public struct Merge: Identifiable {
        public typealias ElementProvider = (MergeSort.Elements.Index) -> Element
        
        public let elementProvider: ElementProvider
        public let fromIndex: MergeSort.Elements.Index
        public let id: UUID
        public let middleIndex: MergeSort.Elements.Index
        public let toIndex: MergeSort.Elements.Index
        
        public private(set) var leftPartitionIndex: MergeSort.Elements.Index
        public private(set) var output: [Transaction]
        public private(set) var outputIndex: MergeSort.Elements.Index
        public private(set) var rightPartitionIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        public init(
            parent: MergeSort,
            fromIndex: MergeSort.Elements.Index,
            middleIndex: MergeSort.Elements.Index,
            toIndex: MergeSort.Elements.Index
        ) {
            self.init(fromIndex: fromIndex, middleIndex: middleIndex, toIndex: toIndex) {
                parent.output[$0]
            }
        }
        
        public init(
            fromIndex: MergeSort.Elements.Index,
            middleIndex: MergeSort.Elements.Index,
            toIndex: MergeSort.Elements.Index,
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
        
        public mutating func answer(_ answer: Comparison<MergeSort>.Answer) {
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
        
        public mutating func callAsFunction() -> [Transaction]? {
            guard arePartitionIndicesInBounds else {
                flushLeftPartition()
                
                return output
            }

            return nil
        }
        
        public func peekAtElement(for answer: Comparison<MergeSort>.Answer) -> Element {
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
}

// MARK: - Merge.Transaction Definition

extension MergeSort.Merge {
    public struct Transaction {
        public let inputIndex: MergeSort.Elements.Index
        public let outputIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        public init(inputIndex: MergeSort.Elements.Index, outputIndex: MergeSort.Elements.Index) {
            self.inputIndex = inputIndex
            self.outputIndex = outputIndex
        }
    }
}
