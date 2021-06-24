//
//  InsertionSort+SortStateUniversityTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 6/22/21.
//

@testable import SortStateUniversity

extension InsertionSort {
    // MARK: Internal Static Interface
    
    static func makeForTest(inputLength: Int, inputState: SortInputFactory.InputState) -> InsertionSort<Int> {
        InsertionSort<Int>(input: SortInputFactory.makeInput(length: inputLength, state: inputState))
    }
}
