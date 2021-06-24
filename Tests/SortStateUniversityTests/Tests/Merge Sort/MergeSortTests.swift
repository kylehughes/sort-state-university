//
//  MergeSortTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 4/18/21.
//

import XCTest

@testable import SortStateUniversity

final class MergeSortTests: XCTestCase {
    typealias Sort = MergeSort<Int>
    typealias TestHarness = SortTestHarness<Sort>
    
    private let harness = TestHarness(sortFactory: Sort.makeForTest)
}

// MARK: - Bespoke Interface Tests

extension MergeSortTests {
    // MARK: Tests
    
    func test_outputAfterTransactions_afterSorting() {
        let sort = harness.perform(inputState: .shuffled)
        XCTAssertEqual(sort.outputAfterTransactions, sort.output)
    }
    
    func test_outputAfterTransactions_beforeSorting() {
        let sort = harness.makeSort(inputState: .shuffled)
        XCTAssertEqual(sort.outputAfterTransactions, sort.output)
    }
    
    func test_outputAfterTransactions_duringSorting() throws {
        try harness.perform(inputState: .shuffled) { previousSort, comparison, currentSort in
            let ongoingMerge = try XCTUnwrap(currentSort.ongoingMerge)
            XCTAssertEqual(currentSort.outputAfterTransactions, currentSort.output.performing(ongoingMerge.output))
        }
    }
}

// MARK: - Algorithm Stability Tests

extension MergeSortTests {
    // MARK: Tests
    
    func test_algorithm_bestCase() {
        harness.testAlgorithm(inputState: .bestCase)
    }
    
    func test_algorithm_shuffled() {
        harness.testAlgorithm(inputState: .shuffled)
    }
    
    func test_algorithm_worstCase() {
        harness.testAlgorithm(inputState: .worstCase)
    }
    
    func test_idempotency_bestCase() {
        harness.testIdempotency(inputState: .bestCase)
    }
    
    func test_idempotency_shuffled() {
        harness.testIdempotency(inputState: .shuffled)
    }
    
    func test_idempotency_worstCase() {
        harness.testIdempotency(inputState: .worstCase)
    }
}

// MARK: - SortingAlgorithm Tests

extension MergeSortTests {
    // MARK: Tests
    
    func test_answer_whileFinished() {
        harness.testAnswerWhileFinished()
    }
    
    func test_calculateMaximumNumberOfComparisonsInWorstCase() {
        harness.testCalculateMaximumNumberOfComparisonsInWorstCase(with: answers)
    }
    
    func test_complexity() {
        harness.testComplexity(expected: .linearithmic)
    }
    
    func test_label() {
        harness.testLabel(expected: .merge)
    }
    
    func test_peekAtElement() {
        harness.testPeekAtElement()
    }
    
    func test_peekAtElement_whileFinished() {
        harness.testPeekAtElementWhileFinished()
    }
    
    // MARK: Private Helpers
    
    private var answers: [Int: Int] {
        [
            0: 0,
            1: 0,
            2: 1,
            3: 3,
            4: 5,
            5: 9,
            6: 11,
            7: 14,
            8: 17,
            9: 25,
            10: 27,
            11: 30,
            12: 33,
            13: 38,
            14: 41,
            15: 45,
            16: 49,
            17: 65,
            18: 67,
            19: 70,
            20: 73,
            21: 78,
            22: 81,
            23: 85,
            24: 89,
            25: 98,
            26: 101,
            27: 105,
            28: 109,
            29: 115,
            30: 119,
            31: 124,
            32: 129,
            33: 161,
            34: 163,
            35: 166,
            36: 169,
            37: 174,
            38: 177,
            39: 181,
            40: 185,
            41: 194,
            42: 197,
            43: 201,
            44: 205,
            45: 211,
            46: 215,
            47: 220,
            48: 225,
            49: 242,
            50: 245,
            51: 249,
            52: 253,
            53: 259,
            54: 263,
            55: 268,
            56: 273,
            57: 283,
            58: 287,
            59: 292,
            60: 297,
            61: 304,
            62: 309,
            63: 315,
            64: 321,
            65: 385,
            66: 387,
            67: 390,
            68: 393,
            69: 398,
            70: 401,
            71: 405,
            72: 409,
            73: 418,
            74: 421,
            75: 425,
            76: 429,
            77: 435,
            78: 439,
            79: 444,
            80: 449,
            81: 466,
            82: 469,
            83: 473,
            84: 477,
            85: 483,
            86: 487,
            87: 492,
            88: 497,
            89: 507,
            90: 511,
            91: 516,
            92: 521,
            93: 528,
            94: 533,
            95: 539,
            96: 545,
            97: 578,
            98: 581,
            99: 585,
            100: 589,
        ]
    }
}
