//
//  tradeInfo.swift
//  SIM
//
//  Created by user147645 on 2/6/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import Foundation

class tradeinfo {
    
    //trade info
    var netAmount = 0.0
    var tradeTpye = ""
    var symbol = ""
    var quantity = 0.0
    var accountType = ""
    var estimatedFee = 0.0
    var transaction = ""
    var name = ""
    var orderType = ""
    var commission = 0.0
    var price = 0.0
    
    //user info to avoid reconnecting
    var user = ""
    var currentGame = ""
    var userCurrentCash = 0.0
    var numberOfTrades = 0
    
    var listOfStocksAndAmounts = [[String:Double]]()
    
    
}
