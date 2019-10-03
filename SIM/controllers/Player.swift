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
    var userNickName = ""
    var firstName = ""
    var lastName = ""
    var playerEmail = ""
    var currentCash = "0"
    var netWorth = "0"
    var listOfStockAndQuantity = ["GoogTest":0.0]
    var gamesInProgress = ["Test game Data"]
    var currentGame = "Test game Data"
    var buyPower = "0"
    var numberOfTrades = "0"
    var currentStockValue = "0"
    var gamesPlayed = 0.0
    var gamesWon = 0.0
    var totalPlayerValue = "0"
    var stockReturnpercentageAtGameEnd = "0"
    var fullName = ""
    var watchListStocks = [String]()
    var winningPercentage = 0.0
}
