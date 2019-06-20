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
    var searchData = ["apple pie","icecream","Footlocker","Cream pie","Foot","Apple"]
    var searchResults =  [String]()


    //IB actions:
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var searchTableViewOutlet: UITableView!
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let userText = searchText.lowercased()
        
        //takes the body of the function and runs it against the outside function. a closure is basically a function that runs another function.
        searchResults = searchData.filter({ (searchElement) -> Bool in
            
            return searchElement.contains(userText)
        })
        
        //working, - takes the $0 data or element of the search data array and runs the contains character function
      //  searchResults = searchData.filter { $0.contains(searchText) }
       
        
        searchTableViewOutlet.reloadData()
        searchTableViewOutlet.isHidden = false
    }
    
    
    
    
    
    //tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableViewOutlet.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
    
            cell.textLabel?.text = searchResults[indexPath.row]
            cell.detailTextLabel?.text = "tester"
        
        return cell
    }
    

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
    }
}
