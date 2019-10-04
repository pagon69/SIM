//
//  Animation.swift
//  SIM
//
//  Created by user147645 on 10/4/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class Animation: UIViewController {

    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var endPointOutlet: UIView!
    @IBOutlet weak var shakeButton: UIButton!
    
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    
    @IBAction func animate(_ sender: UIButton) {
        
        UIView.animate(withDuration: 8.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.hiddenView.transform = CGAffineTransform(translationX: 240, y: 0)
            self.myLabel.alpha = 1.0
            
        }) { (result) in
            
        }
        
        
    }
    
    
    func goRight(){
        
        UIView.animate(withDuration: 0.5) {
            self.shakeButton.transform = CGAffineTransform(translationX: 10.0, y: 0.0)
        }
        
    }
    
    func goLeft(){
        
        UIView.animate(withDuration: 0.5) {
            self.shakeButton.transform = CGAffineTransform(translationX: -20.0, y: 0.0)
        }
        
    }
    
    //tap the screen an the animation happens
    @objc func whenClicked(){
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.goLeft()
            
        }) { (results) in
            
            self.goRight()
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        startPoint = hiddenView.center
        endPoint = endPointOutlet.center
        myLabel.alpha = 0
        // Do any additional setup after loading the view.
        
        

        var myTapGusture = UITapGestureRecognizer(target: self, action: #selector(whenClicked))
      
        self.view.addGestureRecognizer(myTapGusture)
      
        
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
