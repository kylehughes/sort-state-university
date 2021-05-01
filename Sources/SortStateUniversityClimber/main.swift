//
//  main.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/23/21.
//

import Foundation
import SortStateUniversity

/// - SeeAlso: https://en.wikipedia.org/wiki/Merge_sort
/// - SeeAlso: https://en.wikipedia.org/wiki/Sorting_number
/// - SeeAlso: https://oeis.org/A003071
/// - SeeAlso: https://oeis.org/A061338
/// - SeeAlso: https://doc.lagout.org/science/0_Computer%20Science/2_Algorithms/The%20Art%20of%20Computer%20Programming%20%28vol.%203_%20Sorting%20and%20Searching%29%20%282nd%20ed.%29%20%5BKnuth%201998-05-04%5D.pdf

// MARK: - Script

let parallelRecursionQueue = DispatchQueue(label: "parallelRecursion", attributes: [.concurrent], target: .global())
let parallelSpelunkRecursionQueue = DispatchQueue(label: "parallelSpelunkRecursion", attributes: [.concurrent], target: .global())
let parallelSpelunkWriteQueue = DispatchQueue(label: "parallelSpelunkWrite", target: .global())

let ioQueue = DispatchQueue(label: "io", target: .global())
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .long

var cache: [Int: Int] = [
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
]
var counter = 0
var maxDepth = 0
var parallelSpelunkMaxDepth = 0
var parallelSpelunkMaxDepthNumWriteAttempts = 0

private var newCache: [Int: Int] = [:]

//
//countNumberOfNodesInTree(in: MergeSort(input: makeInput(length: 9)))
//
//print(counter)

// MARK: Holy Shit Breakthrough Caching Recursion

for i in 1 ... .max {
    let input = makeInput(length: i)
    let mergeSort = MergeSort(input: input)
    let start = Date()
    let output = cacheCalculateMaximumNumberOfComparisons(in: mergeSort)
    print("\(i) \(output)\t\t\(Date().timeIntervalSince(start))s")
    newCache.removeAll()
    appendToFile(n: i, maxComparisons: output)
}

// MARK: Normal Recursion

//for i in 1...100 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    let output = calculateMaximumNumberOfComparisons(in: mergeSort)
//    print("\(i)\t->\t\(output)")
//    newCache.removeAll()
////    appendToFile(n: i, maxComparisons: output)
//}

//DispatchQueue.concurrentPerform(iterations: 100) {
//    let input = makeInput(length: $0)
//    let mergeSort = MergeSort(input: input)
//    let output = calculateMaximumNumberOfComparisons(in: mergeSort)
//    print("\($0)\t->\t\(output)")
//    appendToFile(n: $0, maxComparisons: output)
//}

// MARK: Normal Iteration

//for i in 1...100 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    let output = iterativelyCalculateMaximumNumberOfComparisons(in: mergeSort)
//    print("\(i)\t->\t\(output)")
//    appendToFile(n: i, maxComparisons: output)
//}

//DispatchQueue.concurrentPerform(iterations: 100) {
//    let input = makeInput(length: $0)
//    let mergeSort = MergeSort(input: input)
//    let output = iterativelyCalculateMaximumNumberOfComparisons(in: mergeSort)
//    print("\($0)\t->\t\(output)")
//    appendToFile(n: $0, maxComparisons: output)
//}

// MARK: Parallel Recursion

//for i in 1...100 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    let output = queueCalculateMaximumNumberOfComparisons(in: mergeSort) {
//        print("\(i)\t->\t\($0)")
//        appendToFile(n: i, maxComparisons: $0)
//    }
//}

//let input = makeInput(length: 13)
//let mergeSort = MergeSort(input: input)
//queueCalculateMaximumNumberOfComparisons(in: mergeSort) {
//    print("\(11)\t->\t\($0)")
//    appendToFile(n: 11, maxComparisons: $0)
//}
//
//while(true) {
//
//}

// MARK: Cached Recursion

//for i in 1...100 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    let output = cacheCalculateMaximumNumberOfComparisons(in: mergeSort)
//    print("\(i)\t->\t\(output)")
////    appendToFile(n: i, maxComparisons: output)
//}

// MARK: Spelunking

//for i in 1 ... 100 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    spelunkCalculateMaximumNumberOfComparisons(in: mergeSort)
//    print("\(i)\t->\t\(maxDepth)")
//    appendToFile(n: i, maxComparisons: maxDepth)
//    maxDepth = 0
//}

//print(calculateNumberOfLeafNodes(n: 3))

//for i in 1...100 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    parallelSpelunkCalculateMaximumNumberOfComparisons(in: mergeSort)
//    let expectedNumberOfWrites = calculateNumberOfLeafNodes(n: i)
//    while parallelSpelunkMaxDepthNumWriteAttempts < expectedNumberOfWrites {
//        // NO-OP
//    }
//    print("\(i)\t->\t\(parallelSpelunkMaxDepth)")
////    appendToFile(n: i, maxComparisons: parallelSpelunkMaxDepth)
//    parallelSpelunkMaxDepth = 0
//    parallelSpelunkMaxDepthNumWriteAttempts = 0
//}
//appendToFile(n: i, maxComparisons: output)

// MARK: Bespoke Cheating Algorithm

//for i in 1...1000 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    let output1 = optimCalculateMaximumNumberOfComparisons(in: mergeSort, useLeft: true)
//    let output2 = optimCalculateMaximumNumberOfComparisons(in: mergeSort, useLeft: false)
//    let output = max(output1, output2)
//    print("\(i)\t->\t\(output)")
//    appendToFile(n: i, maxComparisons: output)
//}

// MARK: Second Bespoke Cheating Algorithm

//for i in 1...100 {
//    let input = makeInput(length: i)
//    let mergeSort = MergeSort(input: input)
//    let output = optim2CalculateMaximumNumberOfComparisons(in: mergeSort)
//    print("\(i)\t->\t\(output)")
////    appendToFile(n: i, maxComparisons: output)
//}

// MARK: - Helper Functions

func iterativelyCalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>) -> Int {
    var mergeSort = mergeSort
    var numberOfComparisons = 0

    var comparisonQueue: [Comparison<MergeSort<Int>>] = [
        mergeSort().comparison
    ].compactMap { $0 }

    while !comparisonQueue.isEmpty {
        numberOfComparisons += 1

        var comparisonsToProcess = comparisonQueue.count

        while 0 < comparisonsToProcess {
            let comparison = comparisonQueue.removeFirst()

            var leftSideOutcome = comparison(.left)
            if let leftSideComparison = leftSideOutcome().comparison {
                comparisonQueue.append(leftSideComparison)
            }

            var rightSideOutcome = comparison(.right)
            if let rightSideComparison = rightSideOutcome().comparison {
                comparisonQueue.append(rightSideComparison)
            }

            comparisonsToProcess -= 1
        }
    }

    return numberOfComparisons
}

func calculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>) -> Int {
    var mergeSort = mergeSort
    
    switch mergeSort() {
    case let .comparison(comparison):
        return max(
            calculateMaximumNumberOfComparisons(in: comparison(.left)),
            calculateMaximumNumberOfComparisons(in: comparison(.right))
        ) + 1
    case .finished:
        return 0
    }
}

func cacheCalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>) -> Int {
    let cacheKey = mergeSort.ongoingMerge.hashValue
    
    if let existingDepth = newCache[cacheKey] {
        return existingDepth
    }
    
    var mergeSort = mergeSort
    
    switch mergeSort() {
    case let .comparison(comparison):
        let depth = max(
            cacheCalculateMaximumNumberOfComparisons(in: comparison(.left)),
            cacheCalculateMaximumNumberOfComparisons(in: comparison(.right))
        ) + 1
        newCache[cacheKey] = depth
        return depth
    case .finished:
        return 0
    }
}

func spelunkCalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>, currentDepth: Int = 0) {
    var mergeSort = mergeSort

    switch mergeSort() {
    case let .comparison(comparison):
        spelunkCalculateMaximumNumberOfComparisons(in: comparison(.left), currentDepth: currentDepth + 1)
        spelunkCalculateMaximumNumberOfComparisons(in: comparison(.right), currentDepth: currentDepth + 1)
    case .finished:
        // could be - 1
        maxDepth = max(maxDepth, currentDepth)
    }
}

//func parallelSpelunkCalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>, currentDepth: Int = 0) {
//    var mergeSort = mergeSort
//
//    switch mergeSort() {
//    case let .comparison(comparison):
//        parallelSpelunkRecursionQueue.async {
//            parallelSpelunkCalculateMaximumNumberOfComparisons(in: comparison(.left), currentDepth: currentDepth + 1)
//        }
//        parallelSpelunkRecursionQueue.async {
//            parallelSpelunkCalculateMaximumNumberOfComparisons(in: comparison(.right), currentDepth: currentDepth + 1)
//        }
//    case .finished:
//        writeToParallelSpelunkDepth(currentDepth)
//    }
//}
//
//func cacheCalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>) -> Int {
//    var mergeSort = mergeSort
//
//    switch mergeSort() {
//    case let .comparison(comparison):
//        let leftValue: Int = {
//            if let cachedValue = cache[comparison.leftSide.outcome.partitionSize] {
//                return cachedValue + 1
//            } else {
//                return cacheCalculateMaximumNumberOfComparisons(in: comparison.leftSide.outcome) + 1
//            }
//        }()
//        let rightValue: Int = {
//            if let cachedValue = cache[comparison.rightSide.outcome.partitionSize] {
//                return cachedValue + 1
//            } else {
//                return cacheCalculateMaximumNumberOfComparisons(in: comparison.rightSide.outcome) + 1
//            }
//        }()
//        return max(
//            leftValue,
//            rightValue
//        ) + 1
//    case .finished:
//        return 0
//    }
//}
//
//func queueCalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>, completion: @escaping (Int) -> Void) {
//    parallelRecursionQueue.async {
//        var mergeSort = mergeSort
//
//        switch mergeSort() {
//        case let .comparison(comparison):
//            queueCalculateMaximumNumberOfComparisons(in: comparison.leftSide.outcome) { left in
//                queueCalculateMaximumNumberOfComparisons(in: comparison.rightSide.outcome) { right in
//                    completion(max(left, right) + 1)
//                }
//            }
//        case .finished:
//            return completion(0)
//        }
//    }
//}
//
//func optimCalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>, useLeft: Bool) -> Int {
//    var mergeSort = mergeSort
//
//    switch mergeSort() {
//    case let .comparison(comparison):
//        switch useLeft {
//        case false:
//            let recursiveReturn = optimCalculateMaximumNumberOfComparisons(in: comparison.rightSide.outcome, useLeft: true)
//            switch recursiveReturn {
//            case 0:
//                return optimCalculateMaximumNumberOfComparisons(in: comparison.leftSide.outcome, useLeft: false) + 1
//            default:
//                return recursiveReturn + 1
//            }
//        case true:
//            let recursiveReturn = optimCalculateMaximumNumberOfComparisons(in: comparison.leftSide.outcome, useLeft: false)
//            switch recursiveReturn {
//            case 0:
//                return optimCalculateMaximumNumberOfComparisons(in: comparison.rightSide.outcome, useLeft: true) + 1
//            default:
//                return recursiveReturn + 1
//            }
//        }
//    case .finished:
//        return 0
//    }
//}
//
//func optim2CalculateMaximumNumberOfComparisons(in mergeSort: MergeSort<Int>, currentDepth: Int = 0) -> Int {
//    var mergeSort = mergeSort
//
//    switch mergeSort() {
//    case let .comparison(comparison):
//        guard mergeSort.input.count - 2 <= currentDepth else {
//            return optim2CalculateMaximumNumberOfComparisons(
//                in: comparison.leftSide.outcome,
//                currentDepth: currentDepth + 1
//            )
//        }
//        return max(
//            optim2CalculateMaximumNumberOfComparisons(in: comparison.leftSide.outcome, currentDepth: currentDepth + 1),
//            optim2CalculateMaximumNumberOfComparisons(in: comparison.rightSide.outcome, currentDepth: currentDepth + 1)
//        )
//    case .finished:
//        return currentDepth
//    }
//}


func appendToFile(n: Int, maxComparisons: Int) {
    ioQueue.async {
        let newLine = "\n\(n) \(maxComparisons)"
        let url = URL(string: "file:///Users/kyle/mergesort.txt")!
        let existingContent = try! String(data: Data(contentsOf: url), encoding: .utf8)!
        let newContext = existingContent + newLine
        try! newContext.write(to: url, atomically: true, encoding: .utf8)
    }
}

/// a legit guess at how this work
func calculateNumberOfLeafNodes(n: Int) -> Int {
    switch n {
    case 1:
        return 1
    case 2:
        return 2
    default:
        return calculateNumberOfLeafNodes(n: n - 1) * n
    }
}

func writeToParallelSpelunkDepth(_ possibleDepth: Int) {
    parallelSpelunkWriteQueue.async {
        if parallelSpelunkMaxDepth < possibleDepth {
            parallelSpelunkMaxDepth = possibleDepth
            print("wrote \(possibleDepth)")
        }
        parallelSpelunkMaxDepthNumWriteAttempts += 1
    }
}

//func countNumberOfNodesInTree(in mergeSort: MergeSort<Int>) {
//    var mergeSort = mergeSort
//
//    switch mergeSort() {
//    case let .comparison(comparison):
//        countNumberOfNodesInTree(in: comparison.leftSide.outcome)
//        countNumberOfNodesInTree(in: comparison.rightSide.outcome)
//        counter += 1
//    case .finished:
//        break
//    }
//}

func makeInput(length: Int) -> [Int] {
    guard 0 < length else {
        return []
    }
    
    var array: [Int] = []
    
    for i in 1 ... length {
        array.append(i)
    }
    
    return array.shuffled()
}
