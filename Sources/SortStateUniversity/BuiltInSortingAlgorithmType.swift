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
    case insertionSort = "insertion-sort"
    
    /// A divide-and-conquer sorting algorithm.
    ///
    /// - SeeAlso: ``MergeSort``
    case mergeSort = "merge-sort"
    
    /// A divide-and-conquer sorting algorithm using a pivot for partitioning.
    ///
    /// - SeeAlso: ``Quicksort``
    case quicksort = "quicksort"
    
    // MARK: Public Static Interface
    
    /// A collection of all values in this type, in alphabetical order (in American English).
    public static let allCasesInAlphabeticalOrder: [Self] = [.insertionSort, .mergeSort, .quicksort,]
    
    // MARK: Public Instance Interface
    
    /// The unique lable of the associated sorting algorithm.
    @inlinable
    public var label: SortingAlgorithmLabel {
        switch self {
        case .insertionSort: .insertionSort
        case .mergeSort: .mergeSort
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
