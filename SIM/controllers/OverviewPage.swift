//
//  OverviewPage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class OverviewPage: UIViewController, UITableViewDataSource,UITableViewDelegate {
   
    //MARK: - globals
    var myTestData = ["Andy", "Ellis", "Scott", "Mark", "Catty"]
    
    
    
    //MARK: - IB actions and outlets
    
    @IBOutlet weak var profileTableViewOutlet: UITableView!
    @IBOutlet weak var aboutTableView: UITableView!
    
    
    @IBAction func invitePlayerClicked(_ sender: UIButton) {
    }
    @IBOutlet weak var welcomeLabel: UINavigationItem!
    
    @IBAction func settingsClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBAction func leaderBoardClicked(_ sender: UIButton) {
    }
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
    }
    
    @IBOutlet weak var rankPicture: UIImageView!
    
    
    
    
    //MARK: - Tableview info
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView.tag == 0){
            count = myTestData.count
        }
        
        if(tableView.tag == 1){
            count = myTestData.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.detailTextLabel?.text = myTestData[indexPath.row]
    
        return cell
    }
    
    //MARK: - view setup then view did load
    func viewSetup() {
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        // Do any additional setup after loading the view.
    }
    

   

}
