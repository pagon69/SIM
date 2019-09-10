//
//  Stock.swift
//  SIM
//
//  Created by user147645 on 6/12/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import Foundation

class Stock {
    
    var symbol = ""
    var companyName = ""
    var calculationPrice = ""
    var open = 0.00
    var openTime = 0
    var close = 0.00
    var closeTime = 0
    var high = 0.00
    var low = 0.00
    var latestPrice = ""
    var latestSource =  ""
    var latestTime = ""
    var latestUpdate = 0
    var latestVolume = 0
    var iexRealtimePrice = 0.00
    var iexRealtimeSize = 0
    var iexLastUpdated = 0
    var delayedPrice = 0.00
    var delayedPriceTime = 0.00
    var extendedPrice = 0.00
    var extendedChange = 0.00
    var extendedChangePercent = 0.00
    var extendedPriceTime = 0
    var previousClose = 0.00
    var change = ""
    var changePercent = ""
    var iexMarketPercent = ""
    var iexVolume = 0
    var avgTotalVolume = 0
    var iexBidPrice = 0.00
    var iexBidSize = 0
    var iexAskPrice = 0.00
    var iexAskSize = 0
    var marketCap = 0
    var week52High = 0.00
    var week52Low = 0.00
    var ytdChange = 0.00
    var type = ""
    
    //needed for game
    var sharesCurrentlyPurchased = 0
    
}
