//
//  Complexity.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 4/19/21.
//

import Foundation

/// The amount of computer time that it takes to run an algorithm.
///
/// This is an estimate of the number of elementary operations performed by the algorithm in relation to the number
/// of elements the algorithm is operating on.
///
/// Algorithms that have the same complexity have running times that are close enough for the sake of analysis but
/// in practice may differ slightly.
///
/// - SeeAlso: https://en.wikipedia.org/wiki/Big_O_notation
public enum Complexity: Equatable, Hashable, CaseIterable {
    /// O(1)
    case constant
    
    /// O(2^n)
    case exponential
    
    /// O(n!)
    case factorial
    
    /// O(n)
    case linear
    
    /// O(n*log(2,n))
    case linearithmic
    
    /// O(log(2,n))
    case logarithmic
    
    /// O(n^2)
    case quadratic
    
    // MARK: Public Static Interface
    
    public static let allCasesInOrder: [Complexity] = [
        .constant,
        .logarithmic,
        .linear,
        .linearithmic,
        .quadratic,
        .exponential,
        .factorial,
    ]
    
    // MARK: Public Instance Interface

    public func calculateWorstCase(for n: Int) -> Int {
        switch self {
        case .constant:
            return 1
        case .exponential:
            let n = Double(n)
            return Self.makeInt(for: exp2(n))
        case .factorial:
            return Self.calculateFactorial(n)
        case .linear:
            return n
        case .linearithmic:
            let n = Double(n)
            return Self.makeInt(for: n * log2(n))
        case .logarithmic:
            let n = Double(n)
            return Self.makeInt(for: log2(n))
        case .quadratic:
            return n * n
        }
    }
    
    // MARK: Private Static Interface
    
    private static func calculateFactorial<N: Numeric>(_ n: N) -> N {
        n == 0 ? 1 : n * calculateFactorial(n - 1)
    }
    
    private static func makeInt(for double: Double) -> Int {
        Int(ceil(double))
    }
}

// MARK: - Comparable Extension

extension Complexity: Comparable {
    // MARK: Public Static Interface
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        allCasesInOrder.firstIndex(of: lhs)! < allCasesInOrder.firstIndex(of: rhs)!
    }
}
