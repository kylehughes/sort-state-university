//
//  Int+SortStateUniversity.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 5/1/21.
//

import Foundation

extension Int {
    // MARK: Public Instance Interface
    
    /// The bit numbers of the current value.
    ///
    /// Values are returned in "most significant bit form", meaning sorted from least to greatest. Values can be
    /// obtained in the "least significant bit" form for applying `sorted(by: >)` to the return value.
    ///
    /// - SeeAlso: https://en.wikipedia.org/wiki/Bit_numbering
    @inlinable
    public var bitNumbers: [Int] {
        var exponents: [Int] = []
        var exponent = 0
        var i = 1
        
        while i <= self {
            defer {
                exponent += 1
                i <<= 1
            }
            
            guard i & self != 0 else {
                continue
            }
            
            exponents.append(exponent)
        }
        
        return exponents
    }
    
    /// The harmonic number of the current value: the sum of the reciprocals of the first `self` positive integers.
    ///
    /// Values less than 1 have a harmonic number of 0 (the empty sum).
    ///
    /// - SeeAlso: https://en.wikipedia.org/wiki/Harmonic_number
    @inlinable
    public var harmonicNumber: Double {
        guard 0 < self else {
            return 0
        }

        var sum = 0.0

        for k in 1 ... self {
            sum += 1.0 / Double(k)
        }

        return sum
    }
}
