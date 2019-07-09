//
//  PopUpViewController.swift
//  SIM
//
//  Created by user147645 on 7/3/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signUpImage: UIImageView!
    
    @IBOutlet weak var popupview: UIView!
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        backButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
        //how you round out corners for a view or anything
        popupview.layer.cornerRadius = 10
        signUpImage.layer.cornerRadius = 10
        //how you mask something, this affects anythign within also
        popupview.layer.masksToBounds = true
        signUpImage.layer.masksToBounds = true
        
        
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
