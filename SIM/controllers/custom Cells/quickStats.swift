//
//  quickStats.swift
//  SIM
//
//  Created by user147645 on 9/16/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class quickStats: UITableViewCell {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var gamesWon: UILabel!
    @IBOutlet weak var gamesPlayed: UILabel!
    @IBOutlet weak var winningPercentage: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
