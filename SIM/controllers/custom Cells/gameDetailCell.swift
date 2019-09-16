//
//  gameDetailCell.swift
//  SIM
//
//  Created by user147645 on 7/18/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit


protocol reactToJoinButtonPush {
    func joinButtonClick(stock: String)
}


class gameDetailCell: UITableViewCell {

    
    @IBOutlet weak var gamedescriptionLabel: UILabel!
    @IBOutlet weak var gameNameOutlet: UILabel!
    @IBOutlet weak var endDateOutlet: UILabel!
    @IBOutlet weak var numberOfPlayersOutlet: UILabel!
    @IBOutlet weak var percentCompleteOutlet: UILabel!
    
    @IBAction func joinButtonClicked(_ sender: UIButton){
      //  print("within join button:")
       // joinButtonClicked(sender)
        
    }
    
    
    //stackViewOutlets
    @IBOutlet weak var labelStackViewOutlet: UIStackView!
    @IBOutlet weak var dataStackViewoutlet: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
