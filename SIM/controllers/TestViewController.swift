//
//  TestViewController.swift
//  SIM
//
//  Created by user147645 on 7/11/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    //required for the UISearchResultsUpdating protocol and also needed to programmacally do this
    func updateSearchResults(for searchController: UISearchController) {
        
        // do something
        filterContentForSearchtext(searchText: searchController.searchBar.text!)
    }
    
    var userInput = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    var test1 = ["goog","aapl","fb","msft"]
    var test2 = [["comapnayname":"Alphabet"],["stocksymbol":"aapl"],["price":"1203.34"],["change":"2.34%"]]
    
    func isFiltering() -> Bool{
        return searchController.isActive && !searchbarIsEmpty()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering(){
            return userInput.count
        }
        
        return test1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! searchResultsCell
        
        cell.companyName.text = test1[indexPath.row]
        cell.stockSymbol.text = "Goog"
        cell.price.text = "1186.54"
        cell.changeLabel.text = "2.34%"
       // cell.TradeButtonOutlet.layer.cornerRadius = 10
        
        
        return cell
    }
    

    @IBOutlet weak var myTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.register(UINib(nibName: "searchResultsCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
    
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search securities"
        definesPresentationContext = true
        
        
        
        
        
    }
    
    func searchbarIsEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchtext( searchText: String, scope: String = "ALL") {
        userInput = test1.filter({ (searchData) -> Bool in
            
            return test1.contains(searchText.lowercased())
        })
        myTableView.reloadData()
        
    }
    
    
}
