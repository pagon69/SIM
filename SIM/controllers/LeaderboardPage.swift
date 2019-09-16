//
//  LeaderboardPage.swift
//  SIM
//
//  Created by user147645 on 8/14/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LeaderboardPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var leaderboardOutlet: UITableView!
    @IBOutlet weak var googleAD: UIView!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var basicDetails: UIView!
    
    @IBOutlet weak var userNameOutlet: UILabel!
    @IBOutlet weak var winlossStats: UILabel!
    @IBOutlet weak var rankNumber: UILabel!
    
    var ref = Database.database().reference()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pullData()
        viewSetup()
        
        // Do any additional setup after loading the view.
    }
    
    func pullData(){
        
        //collects all of the needed user data
        ref.child("leaderboard").observeSingleEvent(of: .value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
            // print(pulleduserdata)
            
        }
        
    }
    
    
    func viewSetup(){
        
         leaderboardOutlet.register(UINib(nibName: "leaderboardCell", bundle: nil), forCellReuseIdentifier: "leaderboardCell")
        
        userProfilePic.image = UIImage(contentsOfFile: "profilePic") 
    }

    @IBAction func backButtonclicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = leaderboardOutlet.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! leaderboardCell
        return cell
        
    }
    
}
