//
//  SortingAlgorithm+SortStateUniversityTests.swift
//  Sort State University
//
//  Created by Kyle Hughes on 7/8/26.
//

import SortStateUniversity

extension SortingAlgorithm where Element: Comparable {
    // MARK: Public Instance Interface

    /// Runs the algorithm to completion, answering every comparison with the `Comparable` convenience, and returns
    /// the sorted output along with the number of comparisons that were answered.
    public func runToCompletion() -> (output: [Element], numberOfComparisons: Int) {
        var sort = self
        var numberOfComparisons = 0

        while true {
            switch sort() {
            case let .comparison(comparison):
                numberOfComparisons += 1
                sort = comparison()
            case let .finished(output):
                return (output, numberOfComparisons)
            }
        }
    }
}
