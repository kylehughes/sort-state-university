//
//  Quicksort+Partition.swift
//  Sort State University
//
//  Created by Kyle Hughes on 6/22/24.
//

extension Quicksort {
    /// Represents a partition of the array being sorted by the ``Quicksort`` algorithm.
    ///
    /// A partition is a section of the array that is being sorted independently. It is defined by a lower bound, an
    /// upper bound, a current index, and a partition index. The ``Quicksort`` algorithm works by repeatedly
    /// partitioning the array and sorting these partitions.
    public struct Partition: Codable, Equatable, Hashable {
        /// The upper bound of the partition in the array being sorted.
        public let high: Elements.Index
        
        /// The lower bound of the partition in the array being sorted.
        public let low: Elements.Index
        
        /// The current index being examined in the partitioning process.
        ///
        /// This index moves from `low` towards `high`, comparing each element with the pivot element.
        public var currentIndex: Elements.Index
        
        /// The index that divides elements less than or equal to the pivot from those greater than the pivot.
        ///
        /// Elements to the left of this index (inclusive) are less than or equal to the pivot, while elements to the
        /// right are greater than the pivot.
        public var partitionIndex: Elements.Index

        /// Creates a new partition with the specified lower and upper bounds.
        ///
        /// Initially, both `currentIndex` and `partitionIndex` are set to `low`.
        ///
        /// - Parameter low: The lower bound of the partition.
        /// - Parameter high: The upper bound of the partition.
        @inlinable
        public init(low: Elements.Index, high: Elements.Index) {
            self.low = low
            self.high = high
            
            currentIndex = low
            partitionIndex = low
        }
    }
}
