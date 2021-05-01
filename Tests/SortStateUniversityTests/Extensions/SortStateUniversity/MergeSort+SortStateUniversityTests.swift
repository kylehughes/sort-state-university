//
//  MergeSort+SortStateUniversityTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 5/1/21.
//

@testable import SortStateUniversity

extension MergeSort {
    // MARK: Internal Static Interface
    
    static func makeForTest(inputLength: Int, inputState: InputState) -> MergeSort<Int> {
        MergeSort<Int>(input: makeInput(length: inputLength, state: inputState))
    }
    
    // MARK: Private Static Interface
    
    private static func makeInput(length: Int, state: InputState) -> [Int] {
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

// MARK: MergeSort.InputState Definition

enum InputState: CaseIterable {
    case bestCase
    case shuffled
    case worstCase
}
