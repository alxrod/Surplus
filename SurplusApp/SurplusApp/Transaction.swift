//
//  Transaction.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/26/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.

import UIKit

class Transaction: NSObject {
    var name: String
    var amount: Double
    
    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
    
}

