//
//  InsertionSortTests.swift
//  SortStateUniversityTests
//
//  Created by Kyle Hughes on 6/22/21.
//

import XCTest

@testable import SortStateUniversity

final class InsertionSortTests: XCTestCase {
    typealias Sort = InsertionSort<Int>
    typealias TestHarness = SortTestHarness<Sort>
    
    private let harness = TestHarness(sortFactory: Sort.makeForTest)
}

// MARK: - Bespoke Interface Tests

extension InsertionSortTests {
    // MARK: Tests
}

// MARK: - Algorithm Stability Tests

extension InsertionSortTests {
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

extension InsertionSortTests {
    // MARK: Tests
    
    func test_answer_whileFinished() {
        harness.testAnswerWhileFinished()
    }
    
    func test_calculateMaximumNumberOfComparisonsInWorstCase() {
        harness.testCalculateMaximumNumberOfComparisonsInWorstCase(with: answers)
    }
    
    func test_complexity() {
        harness.testComplexity(expected: .quadratic)
    }
    
    func test_label() {
        harness.testLabel(expected: .insertion)
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
            4: 6,
            5: 10,
            6: 15,
            7: 21,
            8: 28,
            9: 36,
            10: 45,
            11: 55,
            12: 66,
            13: 78,
            14: 91,
            15: 105,
            16: 120,
            17: 136,
            18: 153,
            19: 171,
            20: 190,
            21: 210,
            22: 231,
            23: 253,
            24: 276,
            25: 300,
            26: 325,
            27: 351,
            28: 378,
            29: 406,
            30: 435,
            31: 465,
            32: 496,
            33: 528,
            34: 561,
            35: 595,
            36: 630,
            37: 666,
            38: 703,
            39: 741,
            40: 780,
            41: 820,
            42: 861,
            43: 903,
            44: 946,
            45: 990,
            46: 1035,
            47: 1081,
            48: 1128,
            49: 1176,
            50: 1225,
            51: 1275,
            52: 1326,
            53: 1378,
            54: 1431,
            55: 1485,
            56: 1540,
            57: 1596,
            58: 1653,
            59: 1711,
            60: 1770,
            61: 1830,
            62: 1891,
            63: 1953,
            64: 2016,
            65: 2080,
            66: 2145,
            67: 2211,
            68: 2278,
            69: 2346,
            70: 2415,
            71: 2485,
            72: 2556,
            73: 2628,
            74: 2701,
            75: 2775,
            76: 2850,
            77: 2926,
            78: 3003,
            79: 3081,
            80: 3160,
            81: 3240,
            82: 3321,
            83: 3403,
            84: 3486,
            85: 3570,
            86: 3655,
            87: 3741,
            88: 3828,
            89: 3916,
            90: 4005,
            91: 4095,
            92: 4186,
            93: 4278,
            94: 4371,
            95: 4465,
            96: 4560,
            97: 4656,
            98: 4753,
            99: 4851,
            100: 4950,
        ]
    }
}
