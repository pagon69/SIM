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
    var marginEnabled: Bool
    var endDate: String
    var partialSharesEnabled: Bool
    var numberOfPlayersInGame: String
    var playersInGameEmail: [String]
    var shortSaleEnabled: Bool
    var startingFunds: String
    var startDate: String
    var percentComplete: String
    var stopLossEnabled: Bool
    
    
    func composeFBData() -> [String: String]{
        var fbData: [String:String] = [:]
        
        fbData = ["commission":"\(commission)",
                  "gameDescription":"\(gameDescription)",
                  "gameName":"\(gameName)",
                  "interestRate":"\(interestRate)",
                  "marginEnabled":"\(marginEnabled)",
                  "endDate":"\(endDate)",
                  "partialSharesEnabled":"\(partialSharesEnabled)",
                  "numberOfPlayersInGame":"\(numberOfPlayersInGame)",
                  "playersInGameEmail":"\(playersInGameEmail)",
                  "shortSaleEnable":"\(shortSaleEnabled)",
                  "startingFunds":"\(startingFunds)",
                  "startDate":"\(startDate)",
                  "percentComplete":"\(percentComplete)",
                  "stopLossEnabled":"\(stopLossEnabled)"
        ]
        
        return fbData
    }
    
    init(commission: String, gameDescription: String,gameName: String, interestRate: String, margin: Bool, endDate: String,partialShares: Bool,playersInGame: [String],shortSale: Bool,startingFunds: String, startDate: String, numberPlayers: String, stopLoss: Bool,percentComplete:  String) {
        self.commission = commission
        self.gameDescription = gameDescription
        self.gameName = gameName
        self.interestRate = interestRate
        self.marginEnabled = margin
        self.endDate = endDate
        self.partialSharesEnabled = partialShares
        self.numberOfPlayersInGame = numberPlayers
        self.playersInGameEmail = playersInGame
        self.shortSaleEnabled = shortSale
        self.startingFunds = startingFunds
        self.startDate = startDate
        self.stopLossEnabled = stopLoss
        self.percentComplete = percentComplete
    }
    
}
