//
//  Merge+Merge+TreeID.swift
//  SortStateUniversityTreeClimber
//
//  Created by Kyle Hughes on 5/1/21.
//

import SortStateUniversity

// MARK: - MergeSort.Merge.ID Definition

extension MergeSort.Merge {
    public struct TreeID: Codable, Equatable, Hashable {
        public let leftPartitionIndex: MergeSort.Elements.Index
        public let rightPartitionIndex: MergeSort.Elements.Index
        
        // MARK: Public Initialization
        
        public init(for merge: MergeSort.Merge) {
            self.init(leftPartitionIndex: merge.leftPartitionIndex, rightPartitionIndex: merge.rightPartitionIndex)
        }
        
        public init(leftPartitionIndex: MergeSort.Elements.Index, rightPartitionIndex: MergeSort.Elements.Index) {
            self.leftPartitionIndex = leftPartitionIndex
            self.rightPartitionIndex = rightPartitionIndex
        }
    }
}

// MARK: - Extension for MergeSort.Merge

extension MergeSort.Merge {
    // MARK: Internal Instance Interface
    
    var treeID: TreeID {
        TreeID(for: self)
    }
}
