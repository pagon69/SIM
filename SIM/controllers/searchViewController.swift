//
//  searchViewController.swift
//  SIM
//
//  Created by user147645 on 6/20/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //global variables
    var searchResults = ["apple pie","icecream","footlocker","cream pie","foot","apple"]
    
    //IB actions:
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var searchTableViewOutlet: UITableView!
    
    //tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableViewOutlet.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
    
            cell.textLabel?.text = "test"
            cell.detailTextLabel?.text = "tester"
        
        return cell
    }
    

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
    }
}
