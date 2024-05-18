//
//  DefaultSortingAlgorithmInputFactory.swift
//  Sort State University
//
//  Created by Kyle Hughes on 5/18/24.
//

public struct DefaultSortingAlgorithmInputFactory {}

// MARK: - SortingAlgorithmInputFactory Extension

extension DefaultSortingAlgorithmInputFactory: SortingAlgorithmInputFactory {
    // MARK: Public Instance Interface
    
    @inlinable
    public func make(_ case: SortingAlgorithmInputCase, count: Int) -> [Int] {
        guard 0 < count else {
            return []
        }
        
        var array: [Int] = []
        
        for i in 1 ... count {
            array.append(i)
        }
        
        switch `case` {
        case .best:
            return array
        case .worst:
            return array.reversed()
        }
    }
}

