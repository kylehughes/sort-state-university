//
//  BuiltInSortingAlgorithmType.swift
//  Sort State University
//
//  Created by Kyle Hughes on 5/12/24.
//

/// Enumeration of all sorting algorithms that are built into the library.
public enum BuiltInSortingAlgorithmType: String, CaseIterable, Equatable, Hashable {
    /// A simple sorting algorithm that sorts its elements one at a time.
    ///
    /// - SeeAlso: ``InsertionSort``
    case insertion = "insertion"
    
    /// A divide-and-conquer sorting algorithm.
    ///
    /// - SeeAlso: ``MergeSort``
    case merge = "merge"
    
    /// A divide-and-conquer sorting algorithm using a pivot for partitioning.
    ///
    /// - SeeAlso: ``Quicksort``
    case quicksort = "quicksort"
    
    // MARK: Public Static Interface
    
    /// A collection of all values in this type, in alphabetical order (in American English).
    public static let allCasesInAlphabeticalOrder: [Self] = [.insertion, .merge, .quicksort,]
    
    // MARK: Public Instance Interface
    
    /// The unique lable of the associated sorting algorithm.
    @inlinable
    public var label: SortingAlgorithmLabel {
        switch self {
        case .insertion: .insertion
        case .merge: .merge
        case .quicksort: .quicksort
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
