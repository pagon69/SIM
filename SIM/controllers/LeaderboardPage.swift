//
//  LeaderboardPage.swift
//  SIM
//
//  Created by user147645 on 8/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class LeaderboardPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
 

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonclicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var leaderboardOutlet: UITableView!
    @IBOutlet weak var googleAD: UIView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = leaderboardOutlet.dequeueReusableCell(withIdentifier: "laderboardCell", for: indexPath) as! leaderboardCell
        return cell
        
    }
    
}
