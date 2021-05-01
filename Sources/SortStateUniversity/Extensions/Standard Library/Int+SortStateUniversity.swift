//
//  Int+SortStateUniversity.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 5/1/21.
//

import Foundation

extension Int {
    // MARK: Public Instance Interface
    
    public var exponentsForDecomposedPowersOfTwo: [Int] {
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
        
        return exponents.sorted(by: >)
    }
    
    // MARK: Internal Instance Interface
    
    func pow(_ exponent: Int) -> Int {
        Int(powf(Float(self), Float(exponent)))
    }
}
