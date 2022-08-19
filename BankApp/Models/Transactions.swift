//
//  Model.swift
//  BankApp
//
//  Created by Zhanna Rolich on 16.08.2022.
//

import RealmSwift

class Transactions: Object {
    @objc dynamic var timeAndDate: String = ""
    @objc dynamic var operation: String = ""
    @objc dynamic var target: String = ""
    @objc dynamic var sum: String = ""
    
    override class func primaryKey() -> String {
        return "sum"
        return "operation"
    }
    
}
