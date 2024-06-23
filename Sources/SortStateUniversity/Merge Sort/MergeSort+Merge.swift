//
//  Merge.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/18/21.
//

import Foundation

extension MergeSort {
    /// An algorithm that takes an array with two sorted partitions and produces one sorted partition in their place.
    ///
    /// This algorithm operates entirely on indices and comparisons so there it has no need to pass arrays or copy
    /// elements. The partitions are defined by the bounds created from indices, and the output are transactions that
    /// need to be applied to the source array.
    ///
    /// The left partition is the elements in the source array between [`fromIndex``, `middleIndex`].
    ///
    /// The right partition is the elements in the source array between (``middleIndex``, ``toIndex``).
    public struct Merge: Codable, Equatable, Hashable, Identifiable {
        /// The position of the first element in the left paritition.
        public let fromIndex: MergeSort.Elements.Index
        
        /// The stable identity of the merge.
        public let id: UUID
        
        /// The position of last element in the left partition.
        ///
        /// The next index is the position of the first element in the right partition.
        public let middleIndex: MergeSort.Elements.Index
        
        /// The position past the last element in the right partition.
        public let toIndex: MergeSort.Elements.Index
        
        /// The current position of the element being compared on behalf of the left partition.
        ///
        /// This is the position of the element represented by `Comparison.left` when this
        /// is the ongoing merge.
        public private(set) var leftPartitionIndex: MergeSort.Elements.Index
        
        /// The transactions that need to be applied to the original array to sort the two sub-lists.
        ///
        /// This value is "live" and will grow as the merge is executed. When the merge is finished this value
        /// will contain all of the transactions that need to be applied to the original array. It is primarily exposed
        /// to allow the internals of the merge to be observed.
        ///
        /// This value should not be used as the final output of the merge unless it is known that the algorithm has
        /// finished. It may be easier to perform ``callAsFunction()`` and respond to the step that is returned – the
        /// output will be reported through that function if the algorithm is finished.
        ///
        /// - SeeAlso: `MergeSort.outputAfterTransactions`
        public private(set) var output: Set<Transaction>
        
        /// The position in the outut of the winner of the comparison between the elements at ``leftPartitionIndex`` and
        /// ``rightPartitionIndex``.
        public private(set) var outputIndex: MergeSort.Elements.Index
        
        /// The current position of the element being compared on behalf of the right partition.
        ///
        /// This is the position of the element represented by `Comparison.right` when this
        /// is the ongoing merge.
        public private(set) var rightPartitionIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        /// Creates an algorithm to merge two sorted partitions within the current output of an ongoing merge sort.
        ///
        /// - Parameter fromIndex: The position of the first element in the left paritition.
        /// - Parameter middleIndex: The position of last element in the left partition.
        /// - Parameter toIndex: The position past the last element in the right partition.
        public init(
            fromIndex: MergeSort.Elements.Index,
            middleIndex: MergeSort.Elements.Index,
            toIndex: MergeSort.Elements.Index
        ) {
            self.fromIndex = fromIndex
            self.middleIndex = middleIndex
            self.toIndex = toIndex
            
            id = UUID()
            leftPartitionIndex = fromIndex
            output = []
            outputIndex = fromIndex
            rightPartitionIndex = middleIndex + 1
        }
        
        // MARK: Public Instance Interface
        
        /// Returns a `Boolean` value indicating whether both the ``leftPartitionIndex`` and ``rightPartitionIndex`` are
        /// within the bounds of their respective partitions.
        ///
        /// This value is `false` if either side is out of bounds.
        ///
        /// - SeeAlso: ``isLeftPartitionIndexInBounds``
        /// - SeeAlso: ``isRightPartitionIndexInBounds``
        @inlinable
        public var arePartitionIndicesInBounds: Bool {
            isLeftPartitionIndexInBounds && isRightPartitionIndexInBounds
        }
        
        /// Returns a `Boolean` value indicating whether or not ``leftPartitionIndex`` is within the bounds of the left
        /// partition.
        ///
        /// The left partition index is in bounds if it is less than or equal to (``middleIndex``).
        @inlinable
        public var isLeftPartitionIndexInBounds: Bool {
            leftPartitionIndex <= middleIndex
        }
        
        /// Returns a `Boolean` value indicating whether or not ``rightPartitionIndex`` is within the bounds of the
        /// right partition.
        ///
        /// The right partition index is in bounds if it is less than or equal to (``toIndex``).
        @inlinable
        public var isRightPartitionIndexInBounds: Bool {
            rightPartitionIndex <= toIndex
        }
        
        /// Answers the current comparison with the given side.
        ///
        /// The merge is advanced to the state that follows the answer. If the answer is ``left`` then the
        /// ``leftTransaction`` will be added to ``output``, otherwise the ``rightTransaction` will be added to output.
        ///
        /// - Parameter answer: The answer to the current comparison.
        public mutating func answer(_ answer: Comparison<MergeSort>.Side) {
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
        
        /// Returns the output of the merge if it is finished.
        ///
        /// If the merge is finished then the returned value is equal to ``output``. If the merge is not finished then
        /// the returned value is equal to `nil`.
        public mutating func callAsFunction() -> Set<Transaction>? {
            guard arePartitionIndicesInBounds else {
                flushLeftPartition()
                
                return output
            }

            return nil
        }
        
        // MARK: Private Instance Interface
        
        /// The transaction that represents the left partition's element winning the current comparison.
        ///
        /// This value is not valid if the merge is finished.
        private var leftTransaction: Transaction {
            Transaction(inputIndex: leftPartitionIndex, outputIndex: outputIndex)
        }
        
        /// The transaction that represents the right partition's element winning the current comparison.
        ///
        /// This value is not valid if the merge is finished.
        private var rightTransaction: Transaction {
            Transaction(inputIndex: rightPartitionIndex, outputIndex: outputIndex)
        }
        
        private mutating func flushLeftPartition() {
            while leftPartitionIndex <= middleIndex {
                output.insert(leftTransaction)
                leftPartitionIndex += 1
                outputIndex += 1
            }
        }
    }
}

// MARK: - MergeSort.Merge.Transaction Definition

extension MergeSort.Merge {
    /// A description of a move to be made in the source array to perform the merge.
    ///
    /// A transaction is focused on a single element in the source array being moved to another position.
    public struct Transaction: Codable, Equatable, Hashable {
        /// The position of the element in the source array when the merge started.
        public let inputIndex: MergeSort.Elements.Index
        
        /// The position the element should be moved to in the source array when the merge is finished.
        public let outputIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        /// Creates a transaction with the given positions.
        ///
        /// - Parameter inputIndex: The position of the element in the source array when the merge started.
        /// - Parameter outputIndex: The position the element should be moved to in the source array when the merge is
        ///   finished.
        @inlinable
        public init(inputIndex: MergeSort.Elements.Index, outputIndex: MergeSort.Elements.Index) {
            self.inputIndex = inputIndex
            self.outputIndex = outputIndex
        }
    }
}
