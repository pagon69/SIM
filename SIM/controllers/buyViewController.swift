//
//  buyViewController.swift
//  SIM
//
//  Created by user147645 on 6/24/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit



class buyViewController: UIViewController {

    var data : Stock?
    
    //ibactions
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            
            //nothing needs to be done just go back
        }

    }
    
    
    
    func alertCode(){
        //basic alert code change to fit and add a yes and no button
        
        
        //defaunt alert code
        let alert = UIAlertController(title: "Market Buy", message: "Purchasing: AAPL at $145.45", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        
        //any need for text in the alerts
        // alert.addTextField { (myTextField) in
        //   myTextField.text = "these are test"
        // }
        
        self.present(alert, animated: true, completion: nil)
        
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
