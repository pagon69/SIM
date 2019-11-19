//
//  FBlearningViewController.swift
//  SIM
//
//  Created by user147645 on 11/13/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FBlearningViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var ref = DatabaseReference()
    var userInput = "test"
    
    var myData: [String:String] = [:]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return myData.count
    }
    
    
    @IBOutlet weak var userInputOutlet: UITextField!
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myData.description
    }
    
    
    @IBAction func userTypedInTextF(_ sender: UITextField) {
    
        userInput = sender.text ?? "Nothing Entered"
      //  print(userInput)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userInput = textField.text ?? "Nothing Entered"
        print(userInput)
    }
    
    
    
    
    @IBOutlet weak var pickerViewOutlet: UIPickerView!
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        ref = Database.database().reference()
        
        let saveMe2 = [
            
            "playersAndInfo":["a@a_com": ["firstName": "andy",
                                           "currentStockValue": 124365,
                                           "playerEmail":"a@a.com",
                                           "listOfStockAndQuantity": ["goog":5,"aapl":4],
                                           "numberOfTrades": 5,
                                           "gamesPlayed": 23,
                                           
                                           "gamesWon":31,
                                           "totalPlayerValue": 23567,
                                           "stockReturnpercentageAtGameEnd": ".34",
                                           "watchListStock": ["goog","aapl","msft"],
                                           "winningPercentage": ".50"
                ]]
            
                        
        ] as [String: Any]
        
        
        let saveMe = [
            "defaultCommission": "5.5",
            "enableCommission":true,
            "startingFunds": "23100",
            "shortSellingEnabled": true,
            "marginSellingEnabled": false,
            "enableLimitOrders": false,
            "enableStopLoss": false,
             "enablePartialShares": [["test5":"tester34"]],
            "playersAndInfo":["x@dx_com": ["firstName": "andy",
                                                      "currentStockValue": 124365,
                                                      "playerEmail":"a@a.com",
                                                      "listOfStockAndQuantity": ["goog":5,"aapl":4],
                                                        "numberOfTrades": 5,
                                                        "gamesPlayed": 23,
         
                                                        "gamesWon":31,
                                                        "totalPlayerValue": 23567,
                                                        "stockReturnpercentageAtGameEnd": ".34",
                                                        "watchListStock": ["goog","aapl","msft"],
                                                        "winningPercentage": ".50"
         ]],
            "playTester":"info"
         
        ] as [String : Any]
        
        
       // if userInput == "Nothing Entered"{
        //    userInput = "testing"
           // ref.child("AndyLearn").child(userInput).setValue(updates)
            
           // ref.child("AndyLearn").child(userInput).updateChildValues(saveMe) { (error, dataRef) in
               
           // }
        
           ref.child("/AndyLearn/\("/test/\("playersAndInfo")")").updateChildValues(saveMe2)
        
           // self.ref.child("AndyLearn").child(self.userInput).updateChildValues(saveMe2)
            
      //  }else {
            
           // ref.child("AndyLearn").child(userInput).setValue(updates)
            
          //  ref.child("AndyLearn").child(userInput).child("playersAndInfo").updateChildValues(saveMe) { (error, dataRef) in
                
           // }
            
         //   self.ref.child("AndyLearn").child(self.userInput).child("playersAndInfo").updateChildValues(saveMe2)
            // ref.child("AndyLearn").child(userInput).setValue(T##value: Any?##Any?)
            
       // }
        
        
    }
    
    @IBAction func subButtonClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pullCurrentData()
        // Do any additional setup after loading the view.
    }
    
    
    func pullCurrentData() {
        ref = Database.database().reference()
        
        ref.child("AndyLearn").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: String] {
                
                self.myData = data
                
                for each in data{
                    
                    
                    //self.myData.append(each)
                }
                
                print(data)
                print("what i have: \(self.myData)")
            }
            
            self.pickerViewOutlet.reloadAllComponents()
            
        }) { (error) in
            
            if error != nil {
                
            }
            
        }
        
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
