//
//  SortInputFactory.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 6/22/21.
//

internal struct SortInputFactory {
    // MARK: Private Initialziation
    
    private init() {
        // NO-OP
    }
    
    // MARK: Internal Static Interface
    
    internal static func makeInput(length: Int, state: InputState) -> [Int] {
        guard 0 < length else {
            return []
        }
        
        var array: [Int] = []
        
        for i in 1 ... length {
            array.append(i)
        }
        
        switch state {
        case .bestCase:
            return array
        case .shuffled:
            return array.shuffled()
        case .worstCase:
            return array.reversed()
        }
    }
}

// MARK: - SortInputFactory.InputState Definition

extension SortInputFactory {
    internal enum InputState: CaseIterable {
        case bestCase
        case shuffled
        case worstCase
    }
}
