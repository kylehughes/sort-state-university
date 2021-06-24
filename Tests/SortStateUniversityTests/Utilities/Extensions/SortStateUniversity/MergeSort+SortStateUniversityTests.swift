//
//  MergeSort+SortStateUniversityTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 5/1/21.
//

@testable import SortStateUniversity

extension MergeSort {
    // MARK: Internal Static Interface
    
    internal static func makeForTest(inputLength: Int, inputState: SortInputFactory.InputState) -> MergeSort<Int> {
        MergeSort<Int>(input: SortInputFactory.makeInput(length: inputLength, state: inputState))
    }
}
