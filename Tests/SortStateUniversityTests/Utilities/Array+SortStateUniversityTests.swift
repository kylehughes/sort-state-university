//
//  Array+SortStateUniversityTests.swift
//  Sort State University
//
//  Created by Kyle Hughes on 7/8/26.
//

extension Array {
    // MARK: Public Instance Interface

    /// Returns every permutation of the array's elements.
    ///
    /// The number of permutations grows factorially; this is only suitable for small arrays.
    @inlinable
    public func allPermutations() -> [[Element]] {
        guard 1 < count else {
            return [self]
        }

        var result: [[Element]] = []

        for index in indices {
            var rest = self
            let element = rest.remove(at: index)

            for var permutation in rest.allPermutations() {
                permutation.insert(element, at: 0)
                result.append(permutation)
            }
        }

        return result
    }
}
