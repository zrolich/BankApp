//
//  RealmService.swift
//  BankApp
//
//  Created by Zhanna Rolich on 19.08.2022.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init(){}
    
    static let shared = RealmService()
    
    var rm = try! Realm()
    
    func create<T: Object>(_ object: T){
        do{
            try rm.write{
                rm.add(object)
            }
        }catch{
            print("Cant create: \(error.localizedDescription)")
        }
    }
    
    func update<T: Object>(_ object: T, dictionary: [String:Any?]){
        do {
            try rm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        }catch {
            print("Cant update: \(error.localizedDescription)")
        }
        
    }
}
