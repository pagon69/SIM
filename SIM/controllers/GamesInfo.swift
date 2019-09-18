//
//  GamesInfo.swift
//  SIM
//
//  Created by user147645 on 7/25/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class GamesInfo {
    
    var defaultCommission: String = "5.5"
    var enableCommission = false
    var gameDescription: String = ""
    var gameName: String = ""
    var marginEnabled: Bool = true
    var endDate: String = ""
    var partialSharesEnabled: Bool = false
    var numberOfPlayersInGame: String = ""
    var playersInGameEmail: [String] = [""]
    
    //can I start as empty with ? and then enter values
    var playersInGameAndCash = [["test":"0.0"]]
    var playersStocksAndAmount = [["testy":[["tester":"0.0"]]]]
    
    var shortSaleEnabled: Bool = true
    var startingFunds: String = ""
    var startDate: String = ""
    var percentComplete: String = ""
    var stopLossEnabled: Bool = true
    var daysRemaining = ""
    var defaultIRC = "3.25"
    var defaultIRD = "6.25"
    var enableInterestRateCredit = false
    var enableInterestRateDebt = false
    var enableLimitOrders = false
    var gameStillActive = true
    var gamesInProgress: [String] = [""]
    var privateGame = false
    var accountReset = false
    var gamePassword = ""
    var resetTodefault = false
    
    
    
    func composeFBData() -> [String: String]{
        var fbData: [String:String] = [:]
        
        fbData = ["commission":"\(defaultCommission)",
                  "gameDescription":"\(gameDescription)",
                  "gameName":"\(gameName)",
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
    
    /*
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
    */
    
}
