//
//  AnimationsViewController.swift
//  Alamofire
//
//  Created by user147645 on 7/3/19.
//

import UIKit

class AnimationsViewController: UIViewController {

    
    //my outlets
   // AnimationsViewController
    @IBOutlet weak var tradeButtonOutlet: UIButton!
    
    @IBOutlet weak var longButtonOutlet: UIButton!
    
    @IBOutlet weak var shortButtonOutlet: UIButton!
    
    @IBOutlet weak var callButtonOutlet: UIButton!
    
    @IBOutlet weak var putButtonOutlet: UIButton!
    
    @IBOutlet weak var sellButtonOutlet: UIButton!
    
    @IBOutlet weak var buyButtonOutlet: UIButton!
    
    //action outlets
    
   
    @IBAction func tradeButtonClicked(_ sender: UIButton) {
     
        //put the animated buttons within a view and contrint that to a specifc area
        
        viewDidLayoutSubviews()
        //if sender.currentImage == image1 {
        
        //expand buttons
        UIView.animate(withDuration: 0.5) {
                //animation within closure
            

            self.buyButtonOutlet.alpha = 1.0
            self.sellButtonOutlet.alpha = 1.0
            self.longButtonOutlet.alpha = 1.0
            self.shortButtonOutlet.alpha = 1.0
            self.putButtonOutlet.alpha = 1.0
            self.callButtonOutlet.alpha = 1.0
            
            self.buyButtonOutlet.center = self.buyButtonCenter
            self.sellButtonOutlet.center = self.sellButtonCenter
            self.longButtonOutlet.center = self.longButtonCenter
            self.shortButtonOutlet.center = self.shortButtonCenter
            self.putButtonOutlet.center = self.putButtonCenter
            self.callButtonOutlet.center = self.callButtonCenter
            
            }
        
        /* need to figure out how to colapse- easy why is to change the picture for the buttons
         //www.youtube.com/watch?v=Mj2Hc6GU8Is - Mark Moeykens views
         
         buyButtonOutlet.center = tradeButtonOutlet.center
         sellButtonOutlet.center = tradeButtonOutlet.center
         longButtonOutlet.center = tradeButtonOutlet.center
         shortButtonOutlet.center = tradeButtonOutlet.center
         putButtonOutlet.center = tradeButtonOutlet.center
         callButtonOutlet.center = tradeButtonOutlet.center
 
 
         */
        
        
        
        
       // }else{
            //colapse the buttons
       // }
        
        /*
        changeButtonImages(button: sender, firstImage: image1, secondImage: image2)
        */
    }
    
    //used to change the image of a button
    func changeButtonImages(button: UIButton, firstImage: UIImage, secondImage: UIImage){
        
        /*
         if button.currentImage == firstImage {
         button.setImage(firstImage, for: .normal)
         }else {
         button.setImage(secondImage, for: .normal)
         }
         */

    }
    
    //globals
    var buyButtonCenter : CGPoint!
    var sellButtonCenter : CGPoint!
    var longButtonCenter : CGPoint!
    var shortButtonCenter : CGPoint!
    var putButtonCenter : CGPoint!
    var callButtonCenter : CGPoint!
    
    //helper functions
    
    func viewSetup(){
        
        viewDidLayoutSubviews()

        //collects the center location for all buttons before anything is done
        buyButtonCenter = buyButtonOutlet.center
        sellButtonCenter = sellButtonOutlet.center
        longButtonCenter = longButtonOutlet.center
        shortButtonCenter = shortButtonOutlet.center
        putButtonCenter = putButtonOutlet.center
        callButtonCenter = callButtonOutlet.center
        
        //sets the alpha to zero for buttons to hide them
        buyButtonOutlet.alpha = 0
        sellButtonOutlet.alpha = 0
        longButtonOutlet.alpha = 0
        shortButtonOutlet.alpha = 0
        putButtonOutlet.alpha = 0
        callButtonOutlet.alpha = 0
        
        //puts all the buttons under trade button
        buyButtonOutlet.center = tradeButtonOutlet.center
        sellButtonOutlet.center = tradeButtonOutlet.center
        longButtonOutlet.center = tradeButtonOutlet.center
        shortButtonOutlet.center = tradeButtonOutlet.center
        putButtonOutlet.center = tradeButtonOutlet.center
        callButtonOutlet.center = tradeButtonOutlet.center
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        
        
        
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
