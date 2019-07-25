//
//  GamesInfo.swift
//  SIM
//
//  Created by user147645 on 7/25/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class GamesInfo {
    
    var commission: String
    var gameDescription: String
    var gameName: String
    var interestRate: String
    var margin: String
    var endDate: String
    var partialShares: String
    var playersInGame: String
    var shortSale: String
    var startingFunds: String
    
    
    func composeFBData() -> [String: String]{
        var fbData: [String:String] = [:]
        
        fbData = ["commission":"\(commission)",
                  "gameDescription":"\(gameDescription)",
                  "gamename":"\(gameName)",
                  "interestRate":"\(interestRate)",
                  "margin":"\(margin)",
                  "endDate":"\(endDate)",
                  "partialShares":"\(partialShares)",
                  "playersInGame":"\(playersInGame)",
                  "shortSale":"\(shortSale)",
                  "startingFunds":"\(startingFunds)"
        ]
        
        return fbData
    }
    
    init(commission: String, gameDescription: String,gameName: String, interestRate: String, margin: String, endDate: String,partialShares: String,playersInGame: String,shortSale: String,startingFunds: String) {
        self.commission = commission
        self.gameDescription = gameDescription
        self.gameName = gameName
        self.interestRate = interestRate
        self.margin = margin
        self.endDate = endDate
        self.partialShares = partialShares
        self.playersInGame = playersInGame
        self.shortSale = shortSale
        self.startingFunds = startingFunds
    }
    
}
