//
//  searchResultsCell.swift
//  SIM
//
//  Created by user147645 on 7/10/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit



protocol reactToButtonPush {
    func callMysegue(myData dataObject: AnyObject)
}

class searchResultsCell: UITableViewCell {

    

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stockSymbol: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var TradeButtonOutlet: UIButton!
    
    @IBAction func tradeButtonAction(_ sender: UIButton) {
        
        print("within the trade button")
       // UIStoryboardSegue(identifier: "customCell", source: Portfolio.self, destination: TradeWindow.self as! UIViewController)
        self.callMySegue()
        /*
        UIStoryboardSegue(identifier: <#T##String?#>, source: <#T##UIViewController#>, destination: <#T##UIViewController#>) {
            <#code#>
        }
        */
        
    }

    func callMySegue(){
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
