//
//  gameDetailCell.swift
//  SIM
//
//  Created by user147645 on 7/18/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit


protocol reactToJoinButtonPush {
    func passInfoFromSelectedCell(currentIndex: Int)

}

class gameDetailCell: UITableViewCell{
    
    @IBOutlet weak var gamedescriptionLabel: UILabel!
    @IBOutlet weak var gameNameOutlet: UILabel!
    @IBOutlet weak var endDateOutlet: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var numberOfPlayersOutlet: UILabel!
    @IBOutlet weak var percentCompleteOutlet: UILabel!
    @IBOutlet weak var joinButtonOutlet: UIButton!
    //stackViewOutlets
    @IBOutlet weak var labelStackViewOutlet: UIStackView!
    @IBOutlet weak var dataStackViewoutlet: UIStackView!
    
    var currentLocations = 0
    var cellDelegate: reactToJoinButtonPush?
    var cellIndex: IndexPath?
    
    override func prepareForReuse() {
       // joinButtonOutlet.titleLabel?.text = ""
    }
    
    @IBAction func joinButtonClicked(_ sender: UIButton){
      //  print("within join button:")
    
        cellDelegate?.passInfoFromSelectedCell(currentIndex: (cellIndex?.row)! )
    
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
