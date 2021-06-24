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
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Constants

extension SortingAlgorithmLabel {
    // MARK: Collections
    
    /// The labels of all sorting algorithms that are built into the library.
    public static let allBuiltIn: [SortingAlgorithmLabel] = [
        .insertion,
        .merge,
    ]
    
    // MARK: Individual Sorts
    
    /// The label of the `InsertionSort` algorithm.
    public static let insertion = SortingAlgorithmLabel(id: "insertion", name: "Insertion Sort")
    
    /// The label of the `MergeSort` algorithm.
    public static let merge = SortingAlgorithmLabel(id: "merge", name: "Merge Sort")
}
