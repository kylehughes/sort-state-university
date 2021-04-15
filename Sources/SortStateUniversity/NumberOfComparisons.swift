//
//  NumberOfComparisons.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/29/21.
//

public enum NumberOfComparisons {
    case ceiling(Int)
    case exact(Int)
    
    // MARK: Public Static Interface
    
    public static func ceiling(for n: Int, using complexity: Complexity) -> NumberOfComparisons {
        .ceiling(complexity.calculateWorstCase(for: n))
    }
}
