//
//  Player.swift
//  SIM
//
//  Created by user147645 on 6/12/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class Player {
    
    var userNickName: String = "Dee"
    var playerEmail: String = "test@tester.com"
    var currentCash: Double = 100000.00
    var userTotalWorth: Double = 0.0
    var listOfStock = [Stock]()
    var listOfStringStock = "goog"
    
    var totalStockValue: Double = 0.0
    var totalPlayerValue: Double = 0.0
    
    /*
    init(userName: String, currentCash: Double, totalStockValue: Double, userTotalWorth: Double, totalPlayerValue: Double) {
        
        self.userName = userName
        self.currentCash = currentCash
        self.totalStockValue = totalStockValue
        self.userTotalWorth = userTotalWorth
        //self.listOfStock = listOfStock
        self.totalPlayerValue = totalPlayerValue

    }
    */
    
    func calculateTotalValue() -> Double{
       // var total = 0.00
        
        for each in listOfStock{
            totalStockValue = totalStockValue + (each.latestPrice * Double(each.sharesCurrentlyPurchased) )
        }

        return totalStockValue
    }
    
    
    
    
}
