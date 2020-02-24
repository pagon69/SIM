//
//  BigGoogleAd.swift
//  SIM
//
//  Created by user147645 on 2/24/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import UIKit
import GoogleMobileAds


// huge commercial for when the user selects deep dive
//load an AD in previous screen
class BigGoogleAd: UIViewController, GADInterstitialDelegate {

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        let interstitial = createAndLoadInterstitial()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let interstitial: GADInterstitial!
     
        interstitial = createAndLoadInterstitial()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
