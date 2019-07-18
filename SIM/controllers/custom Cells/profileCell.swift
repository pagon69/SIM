//
//  profileCell.swift
//  SIM
//
//  Created by user147645 on 7/18/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class profileCell: UITableViewCell {

    //stackView IBs
    @IBOutlet weak var worthLabelsStackView: UIStackView!
    @IBOutlet weak var remainingCashStackView: UIStackView!
    @IBOutlet weak var worthDateStackView: UIStackView!
    @IBOutlet weak var dataCashStackView: UIStackView!
    
    // my IB outlets
    
    @IBOutlet weak var cashRemainingOutlet: UILabel!
    @IBOutlet weak var netWorthOutlet: UILabel!
    @IBOutlet weak var overAllGainsOutlet: UILabel!
    @IBOutlet weak var returnsPercentageOutlet: UILabel!
    
    @IBOutlet weak var trendingPercentageOutlet: UILabel!
    @IBOutlet weak var buyingPowerOutlet: UILabel!
    @IBOutlet weak var shortReservesOutlet: UILabel!
    @IBOutlet weak var debtRemainingOutlet: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
