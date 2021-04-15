//
//  Array+SortStateUniversity.swift
//  SortStateUniversity
//
//  Created by Kyle Hughes on 5/3/21.
//

extension Array {
    // MARK: Internal Instance Interface
    
    internal mutating func perform(_ transactions: Set<MergeSort<Element>.Merge.Transaction>) {
        let input = self
        
        for transaction in transactions {
            self[transaction.outputIndex] = input[transaction.inputIndex]
        }
    }
    
    internal func performing(_ transactions: Set<MergeSort<Element>.Merge.Transaction>) -> Self {
        var copy = self
        copy.perform(transactions)
        
        return copy
    }
}
