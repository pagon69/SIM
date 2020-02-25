//
//  sellObjectCell.swift
//  SIM
//
//  Created by user147645 on 2/25/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import UIKit

class sellObjectCell: UITableViewCell {

    
    
    
    
    
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var sellQuantity: UILabel!
    @IBOutlet weak var sellAmountTextBoxOutlet: UITextField!
    
    
    @IBAction func sellTextBoxtouched(_ sender: UITextField) {
    }
    
    @IBAction func plusButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func minusButtonClicked(_ sender: UIButton) {
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
