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
    
    // MARK: Internal Instance Interface
    
    internal func pow(_ exponent: Int) -> Int {
        Int(powf(Float(self), Float(exponent)))
    }
}
