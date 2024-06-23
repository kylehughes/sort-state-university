//
//  QuicksortTests.swift
//  Sort State University
//
//  Created by Kyle Hughes on 6/22/24.
//

import XCTest

@testable import SortStateUniversity

final class QuicksortTests: AbstractSortingAlgorithmTests<Quicksort<Int>> {
    // MARK: AbstractSortingAlgorithmTests Implementation
    
    override var expectedAverageNumberOfComparisons: [Int : Int] {
        [
            0: 0,
            1: 0,
            2: 1,
            3: 2,
            4: 4,
            5: 6,
            6: 9,
            7: 12,
            8: 15,
            9: 18,
            10: 22,
            11: 26,
            12: 30,
            13: 34,
            14: 38,
            15: 42,
            16: 47,
            17: 52,
            18: 56,
            19: 61,
            20: 66,
            21: 71,
            22: 76,
            23: 81,
            24: 87,
            25: 92,
            26: 97,
            27: 103,
            28: 109,
            29: 114,
            30: 120,
            31: 126,
            32: 132,
            33: 138,
            34: 144,
            35: 150,
            36: 156,
            37: 162,
            38: 168,
            39: 174,
            40: 181,
            41: 187,
            42: 193,
            43: 200,
            44: 206,
            45: 213,
            46: 219,
            47: 226,
            48: 233,
            49: 239,
            50: 246,
            51: 253,
            52: 260,
            53: 266,
            54: 273,
            55: 280,
            56: 287,
            57: 294,
            58: 301,
            59: 308,
            60: 315,
            61: 322,
            62: 330,
            63: 337,
            64: 344,
            65: 351,
            66: 359,
            67: 366,
            68: 373,
            69: 381,
            70: 388,
            71: 395,
            72: 403,
            73: 410,
            74: 418,
            75: 425,
            76: 433,
            77: 441,
            78: 448,
            79: 456,
            80: 464,
            81: 471,
            82: 479,
            83: 487,
            84: 494,
            85: 502,
            86: 510,
            87: 518,
            88: 526,
            89: 534,
            90: 542,
            91: 549,
            92: 557,
            93: 565,
            94: 573,
            95: 581,
            96: 589,
            97: 597,
            98: 605,
            99: 614,
            100: 622,
        ]
    }
    
    override var expectedComplexity: Complexity {
        .linearithmic
    }
    
    override var expectedMaximumNumberOfComparisons: [Int : Int] {
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
    
    override var expectedLabel: SortingAlgorithmLabel {
        .quicksort
    }
    
    override var expectedMinimumNumberOfComparisons: [Int : Int] {
        [
            0: 0,
            1: 0,
            2: 1,
            3: 2,
            4: 4,
            5: 5,
            6: 7,
            7: 8,
            8: 11,
            9: 12,
            10: 14,
            11: 15,
            12: 18,
            13: 19,
            14: 21,
            15: 22,
            16: 26,
            17: 27,
            18: 29,
            19: 30,
            20: 33,
            21: 34,
            22: 36,
            23: 37,
            24: 41,
            25: 42,
            26: 44,
            27: 45,
            28: 48,
            29: 49,
            30: 51,
            31: 52,
            32: 57,
            33: 58,
            34: 60,
            35: 61,
            36: 64,
            37: 65,
            38: 67,
            39: 68,
            40: 72,
            41: 73,
            42: 75,
            43: 76,
            44: 79,
            45: 80,
            46: 82,
            47: 83,
            48: 88,
            49: 89,
            50: 91,
            51: 92,
            52: 95,
            53: 96,
            54: 98,
            55: 99,
            56: 103,
            57: 104,
            58: 106,
            59: 107,
            60: 110,
            61: 111,
            62: 113,
            63: 114,
            64: 120,
            65: 121,
            66: 123,
            67: 124,
            68: 127,
            69: 128,
            70: 130,
            71: 131,
            72: 135,
            73: 136,
            74: 138,
            75: 139,
            76: 142,
            77: 143,
            78: 145,
            79: 146,
            80: 151,
            81: 152,
            82: 154,
            83: 155,
            84: 158,
            85: 159,
            86: 161,
            87: 162,
            88: 166,
            89: 167,
            90: 169,
            91: 170,
            92: 173,
            93: 174,
            94: 176,
            95: 177,
            96: 183,
            97: 184,
            98: 186,
            99: 187,
            100: 190,
        ]
    }
    
    override var inputFactory: any SortingAlgorithmInputFactory {
        DefaultSortingAlgorithmInputFactory()
    }
    
    override func target(for input: [Int]) -> Quicksort<Int> {
        Quicksort(input: input)
    }
}