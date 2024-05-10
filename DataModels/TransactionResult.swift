//
//  TransactionResult.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 26/04/24.
//

import Foundation

public class TransactionResult {
    
    public var transactions : [ Transaction ]
    public var metaData : MetaData
    
    init(transactions: [ Transaction ], metaData: MetaData) {
        self.transactions = transactions
        self.metaData = metaData
    }
}
