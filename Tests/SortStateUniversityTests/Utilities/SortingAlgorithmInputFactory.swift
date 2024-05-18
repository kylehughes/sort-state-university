//
//  SortingAlgorithmInputFactory.swift
//  Sort State University
//
//  Created by Kyle Hughes on 5/18/24.
//

public protocol SortingAlgorithmInputFactory {
    // MARK: Instance Interface
    
    func make(_ case: SortingAlgorithmInputCase, count: Int) -> [Int]
}
