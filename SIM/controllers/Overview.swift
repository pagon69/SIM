//
//  Overview.swift
//  SIM
//
//  Created by user147645 on 7/18/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class Overview: UIViewController {

    
    
    
    
    // ib actions and outlets
    @IBAction func leaderboardClick(_ sender: UIButton) {
    }
    @IBOutlet weak var profileIconWithinNav: UIBarButtonItem!
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    
    
    @IBAction func profileIconWithinNavClicked(_ sender: UIBarButtonItem) {
    }
    
    
    @IBOutlet weak var rankIcon: UIImageView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var aboutTableView: UITableView!
    
    
    @IBAction func inviteUsersClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
