//
//  SIMGame.swift
//  SIM
//
//  Created by user147645 on 6/12/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class SIMGame{
    
    //track progress through games
    var inProgress = false
    
    //compare player profolio values
    
    //do short sales
    
    
    //do buy
    
    func buyStock(currentCash: Double, stockToBuy: Stock, QuantitytoBuy: Int, currentPlayer: Player ) {
        
        //use https://cloud.iexapis.com/stable/stock/aapl/price with totken to get price, update the currentPrice when it comes in
        
        currentPlayer.currentCash = currentCash - ( stockToBuy.latestPrice * Double(QuantitytoBuy) )
        stockToBuy.sharesCurrentlyPurchased = QuantitytoBuy
        currentPlayer.listOfStock.append(stockToBuy)
        
    }
    
    
    
    //do sell
    
    
    
    
    
    //tranding information
}
