//
//  inGameDetailsCell.swift
//  SIM
//
//  Created by user147645 on 9/23/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class inGameDetailsCell: UITableViewCell {

    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userNetWorth: UILabel!
    @IBOutlet weak var inGameRank: UILabel!
    @IBOutlet weak var overAllGains: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
