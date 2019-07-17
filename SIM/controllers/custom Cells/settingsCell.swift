//
//  settingsCell.swift
//  SIM
//
//  Created by user147645 on 7/15/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class settingsCell: UITableViewCell {

    var defaultsValue = [true,
                         false,
                         false,
                         false,
                         false,
                         true,
                         false,
                         false,
                         false]
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    //tracks the state of the switch
    @IBAction func switchChangeState(_ sender: UISwitch) {
        
        
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
