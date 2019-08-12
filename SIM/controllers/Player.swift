//
//  Player.swift
//  SIM
//
//  Created by user147645 on 6/12/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class Player {
    
    //displayname = usernickName may need to change this
    var userNickName: String?
    var playerEmail: String = ""
    var currentCash: String = ""
    var userTotalWorth: String = ""
    var listOfStock = [Stock]()
    var listOfStringStock = ""
    var numberOfTrades: String = ""
    var totalStockValue: Double = 0.0
    var totalPlayerValue: String = ""
    
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
