//
//  Portfolio.swift
//  SIM
//
//  Created by user147645 on 7/8/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class Portfolio: UIViewController {

    
    
    //globals and IBactions
    
    var middleCenter : CGPoint!
    var bannerCenter : CGPoint!
    var bottomCenter : CGPoint!
    
    @IBOutlet weak var profileIconOutlet: UIImageView!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var middleImageOutlet: UIImageView!
    @IBOutlet weak var labelOutlet: UILabel!
    
    //animate to come from left
    @IBOutlet weak var bannerOutlet: UIView!
    
    //animate to come from right
    @IBOutlet weak var middleWindow: UIView!
    
    //anitmate from bottom
    @IBOutlet weak var bottomWindowOutlet: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //start my animations
        setupViews()
        animateViews()
    }
    
//helper functions
    func setupViews(){
        
        //collecting the current center points
        middleCenter = middleWindow.center
        bottomCenter = bottomWindowOutlet.center
        bannerCenter = bannerOutlet.center
        
        //bannerOutlet.alpha = 0.0
        
        //moves the views off screen or disables
        bannerOutlet.center = CGPoint(x: 172.0, y: -75.0)
        middleWindow.center = CGPoint(x: -250.0, y: 253.0)
        bottomWindowOutlet.center = CGPoint(x: 187.0, y: 900.0)
    }
    
    func animateViews(){
        
        UIView.animate(withDuration: 5.0) {
           // self.bannerOutlet.alpha = 1.0
            self.bannerOutlet.center = self.bannerCenter
            self.middleWindow.center = self.middleCenter
            self.bottomWindowOutlet.center = self.bottomCenter
            
        }
        
        
    }
    

}
