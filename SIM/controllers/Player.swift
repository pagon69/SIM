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
    var firstName = ""
    var lastName = ""
    var playerEmail = ""
    var currentCash = ""
    var netWorth = ""
    var listOfStockAndQuantity = ["":0.0]
    var gamesInProgress = [""]
    var currentGame = ""
    var buyPower = ""
    var numberOfTrades = ""
    var currentStockValue = ""
    var gamesPlayed = 0
    var gamesWon = 0.0
    var totalPlayerValue = ""
    var stockReturnpercentageAtGameEnd = ""
    var fullName = ""
    var watchListStocks: [String]?
}
