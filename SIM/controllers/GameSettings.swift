//
//  GameSettings.swift
//  SIM
//
//  Created by user147645 on 7/15/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class GameSettings: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todaysDate = Date()
    var selectedDate = Date()
    
    //IB actions and outlets
    
    @IBOutlet weak var startingFundsLabel: UILabel!
    @IBOutlet weak var startingFundText: UITextField!
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //selected dates
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        selectedDate = sender.date
        
        
        
    }
    
    
    @IBAction func backButtonClick(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            
        }
    }
    
    // game default settings
    
    var defaultSettings = ["Short Sell",
                           "Margin",
                           "Limit Orders",
                           "Stop Loss",
                           "Partial Shares",
                           "Commision",
                           "Interest rate (Credit)",
                           "Interest rate (Debt)" ]
    
    var defaultsValue = [true,
                         false,
                         false,
                         false,
                         false,
                         true,
                         false,
                         false,
                         false]
    
    
    // helper functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsCell
        
        cell.settingsLabel.text = defaultSettings[indexPath.row]
        cell.settingsSwitch.isOn = defaultsValue[indexPath.row]
        
        return cell
    }
    
    func setupSettings(){
        
    }
    
    func viewSetup(){
        datePicker.date = todaysDate
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.register(UINib(nibName: "settingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        viewSetup()
        // Do any additional setup after loading the view.
    }
    

    
    
    

}
