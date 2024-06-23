//
//  SortingAlgorithmLabel.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 6/24/21.
//

/// The type used to uniquely identify a sorting algorithm implementation.
public struct SortingAlgorithmLabel: Codable, Equatable, Hashable, Identifiable {
    /// The stable identity of the sorting algorithm label.
    public let id: String
    
    /// The name of the associated sorting algorithm.
    ///
    /// Suitable for display in UI.
    ///
    /// All names from the library are supplied in English.
    public let name: String
    
    // MARK: Public Initialization
    
    /// Creates a new label for a sorting algorithm.
    ///
    /// - Parameter name: The name of the sorting algorithm.
    @inlinable
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Constants

extension SortingAlgorithmLabel {    
    // MARK: Built-In Sorting Algorithms
    
    /// The label of the ``InsertionSort`` algorithm.
    public static let insertionSort = SortingAlgorithmLabel(id: "insertion-sort", name: "Insertion Sort")
    
    /// The label of the ``MergeSort`` algorithm.
    public static let mergeSort = SortingAlgorithmLabel(id: "merge-sort", name: "Merge Sort")
    
    /// The label of the ``Quicksort`` algorithm.
    public static let quicksort = SortingAlgorithmLabel(id: "quicksort", name: "Quicksort")
}
