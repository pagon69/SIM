//
//  JSonStockCodeable.swift
//  SIM
//
//  Created by user147645 on 1/16/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import Foundation

struct JsonStockCodeable: Codable {
    
    var symbol: String?
    var companyName: String?
    var peRatio: Double?
    var latestPrice: Double?
    var change: Double?
    var week52High: Double?
    var week52Low: Double?
    var primaryExchange: String?
    var lastTradeTime: Double?
    var calculationPrice: String?
    var open: Double?
    var openTime: String?
    var close: Double?
    var closeTime: String?
    var high: Double?
    var low: Double?
    var isUSMarketOpen: Bool?
    var latestSource: String?
    var latestTime: String?
        var latestUpdate: Double?
        var latestVolume: Double?
        var iexRealtimePrice: Double?
        var iexRealtimeSize: Double?
        var iexLastUpdated: Double?
        var delayedPrice: Double?
        var delayedPriceTime: Double?
        var extendedPrice: Double?
        var extendedChange: Double?
        var extendedChangePercent: Double?
    var extendedPriceTime: Double?
    var previousClose: Double?
    var previousVolume: Double?
    var changePercent: Double?
    var iexMarketPercent: Double?
    var iexVolume: Double?
    var avgTotalVolume: Double?
    var iexBidPrice: Double?
    var iexBidSize: Double?
    var iexAskPrice: Double?
    var iexAskSize: Double?
    var marketCap: Double?
    var ytdChange: Double?
    var type: String?
        //needed for game
    var sharesCurrentlyPurchased: Double?
 
 
}

