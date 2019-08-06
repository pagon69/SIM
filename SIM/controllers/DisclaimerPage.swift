//
//  DisclaimerPage.swift
//  SIM
//
//  Created by user147645 on 8/6/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class DisclaimerPage: UIViewController {

    //MARK: - outlets and actions
    
    
    @IBAction func backButtomClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            
            // go back to previous screen
            
        }
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
