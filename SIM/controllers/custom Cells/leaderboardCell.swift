//
//  leaderboardCell.swift
//  SIM
//
//  Created by user147645 on 8/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class leaderboardCell: UITableViewCell {

    @IBOutlet weak var nameLabelOutlet: UILabel!
    @IBOutlet weak var netWorthOutlet: UILabel!
    @IBOutlet weak var rankViewOutlet: UIView!
    @IBOutlet weak var rankLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
