//
//  BuiltInSortingAlgorithmType.swift
//  Sort State University
//
//  Created by Kyle Hughes on 5/12/24.
//

/// Enumeration of all sorting algorithms that are built into the library.
public enum BuiltInSortingAlgorithmType: Equatable, Hashable {
    /// A simple sorting algorithm that sorts its elements one at a time.
    ///
    /// - SeeAlso: ``InsertionSort``
    case insertion
    
    /// A divide-and-conquer sorting algorithm.
    ///
    /// - SeeAlso: ``MergeSort``
    case merge
    
    // MARK: Public Instance Interface
    
    /// The unique lable of the associated sorting algorithm.
    @inlinable
    public var label: SortingAlgorithmLabel {
        switch self {
        case .insertion: .insertion
        case .merge: .merge
        }
    }
}

// MARK: - Identifiable Extension

extension BuiltInSortingAlgorithmType: Identifiable {
    // MARK: Public Instance Interface
    
    @inlinable
    public var id: Self {
        self
    }
}
