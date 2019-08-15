//
//  AppDelegate.swift
//  SIM
//
//  Created by user147645 on 5/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
//import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    //remove when done testing
    var nickName = ""
    var email = ""
    var cash = ""
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            //if an error happens print it out
            print(error)
            return
        }else {

            let userId = user.userID                  // For client-side use only!
            print(userId ?? "")
            
            let idToken = user.authentication.idToken // Safe to send to the server
            print(idToken ?? "")
            
            let fullName = user.profile.name
            print(fullName ?? "")
            
            let givenName = user.profile.givenName
            print(givenName ?? "")
            
            let familyName = user.profile.familyName
            print(familyName ?? "")
            
            let email = user.profile.email
            print(email ?? "")
            
            
 
        }
        
        guard let authentication = user.authentication else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    
        Auth.auth().signIn(with: credentials) {( authResult, error) in
            
            if let error = error {
                print(error)
                return
            }
            
        }
    
    }
    
    
    
    // google disconnect handler
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //what to do when the user disconnects
        
        let firebaseAUTH = Auth.auth()
        
        do{
            try firebaseAUTH.signOut()
        }catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
    }

    /*
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        }
    }
    */
  
    var window: UIWindow?

    
    
    //deployed for google signin
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    // for legacy ios devices and google sign in
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    //edit me for db search and wcreation
    func buildDefaultDB(){
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        let userProfileData = ["new game gam what now": [
            "gameName":"news game game what now",
            "Description":"last one i will make within code, remainign will be dynamic, i feel better about how this is working out now that i see it live. ow to search nd find it",
            "endDate":"9/20/2019",
            "numberOfPlayers":"4",
            "daysRemaining":"12",
            "PlayersInGame": ["a@a.com","b@b.com","c@c.com","d@d.com"],
            "startingFunds": "180000",
            "shortSellingEnabled": "true",
            "marginSellingEnabled": "true",
            "enableLimitOrders": "false",
            "enableStopLoss": "true",
            "enablePartialShares": "true",
            "enableCommision":"true",
            "defaultCommission":"5.5",
            "enableInterestRateCredit":"false",
            "defaultIRC":"5.50",
            "enableInterestRateDebit":" true",
            "defaultIRD":"12.65",
            "gameStillGoing":"true"
            ]]

        let test1 = ["d@d_com": [
            "playerEmail":"d@d.com",
            "listOfStockAndQuantity": [["aapl":"123"],["goog":"1"],["fb":"34"],["msft":"300"]],
            "userNickName": "Mister D",
            "gamesInProgress": ["my first game","yet another game", "Test another One", "another one"],
            "currentCash": "615000",
            "networth": "1509200",
            "buyPower": "571200",
            "currentStockValue": "164000"
            
            
            ]]
        
        // ref.childByAutoId().child("GamesTest").setValue(userProfileData)
        //  var ref: DatabaseReference!
      // ref.child("gamesInProgressByGameName").childByAutoId().setValue(userProfileData)
       // ref.child("userDataByEmail").childByAutoId().setValue(test1)
    }
    
    
    
    
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        //MARK: - Chameleon pod with color choices
        //Chameleon.setGlobalThemeUsingPrimaryColor(UIColor.flatNavyBlueColorDark(), with: .light)
       // Chameleon.setGlobalThemeUsingPrimaryColor(UIColor.flatNavyBlue(), withSecondaryColor: UIColor.flatWhite(), andContentStyle: .contrast)
        
        //database information
        var myDatabaseRef = Database.database().reference()
         // myDatabaseRef.setValue("testing")
        
      //  var ref: DatabaseReference!
        
        buildDefaultDB()
        
        //MARK: - Code for adding Dbs a smarter way:  remove after DB is created
        let gamesAndPlayers = ["b@b_com": ["cash":"100","test":"123456","playersInGame":["a@a.com","d@d.com","b@b.com"]]]
        
      //  myDatabaseRef.child("ActivePlayers").childByAutoId().setValue(gamesAndPlayers)
        

        // working on database knowledge
        var username = "Mandy Moor"
        var emailAddress : String? = "a@a.com"
        
        var newString = ""
        var changeChar = "_"
        
        //removes the . and adds _
        if let oldString = emailAddress{
            
            for letter in oldString{
                
                if letter == "." {
                    newString = newString + String(changeChar)
                }else{
                  newString = newString + String(letter)
                }
                
            }
            
        }
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        //ref.child("users").child("1234567").setValue(["username" : "Andy Alleyne"])
        
        var userDetails : [[String:String]]
        var userDetailsTwo : [String: String]
        var userDetailsThree : [String: String]
        
        //created an array of dictionarys which contain Strings
        userDetails = [["userNickName":"Dee"],
                       ["playerEmail":"AndyA@hotmail.com"],
                       ["currentCash":"125765.00"],
                       ["usersTotalWorth":"435040.53"],
                       ["listOfStock":"aapl,goog,fb,msft"]]
        
        
        //this method is much better than the above because it is easier to get the data out
        userDetailsTwo = ["usernickname":"test1",
                          "playerEmail":"a@a.com",
                          "currentCash":"34567.93",
                          "userTotalWorth":"53490.01",
                          "listOfStock":"aapl,fb,msft",
                          "gameInProgress":"false",
                          "gamesJoined":"testGame1,testgame2",
                          "currentGame":"testGame1",
                        ]
        
        userDetailsThree = ["playersInGame":"a@a.com,andy.alleyne@hotmail.com,asia.alleyne@outlook.com",
                          "gameEndDate":"8-23-2019",
                          "daysRemaining":"40",
                          "gameInProgress":"true",
                          "gameName":"testGame1"
            
        ]
        
        var userDetailsFour = ["numberOfLiveGames":"1","UseForMissingAttributes":"inTheFuture" ]
        
        
        //creates a database call SIMPlyerScores, makes the key name the users email address and adds data.
      //  ref.child("GameUsers/\(newString)").setValue(userDetailsTwo)
      
       // ref.child("NumberOfGamesInProgress/SIM").setValue(userDetailsFour)
        
        //reading data from the DB, generic without naming what to look for
        ref.observe(DataEventType.value) { (snapShot) in
            let pulleduserdata = snapShot.value as? [[String:String]] ?? [[:]]
          //  print(pulleduserdata)
        }
        
 //displays everything within the Stock- SM FB database
        ref.queryOrdered(byChild: "userDataByEmail").observe(.value) { (snaphot) in
          //  print(snaphot)
            
        }
        
        //same as above but faster
        ref.queryOrdered(byChild: "userDataByEmail").observeSingleEvent(of: .value) { (snapshot) in
            
            let pulleduserdata = snapshot.value as? [String:[String:String]] ?? ["":[:]]
          ///  print(pulleduserdata)
        //print(snapshot)
            
        }
        
        //doesnt work
        ref.queryEqual(toValue: "userDataByEmail").observeSingleEvent(of: .value) { (snapshot) in
            
            let pulleduserdata = snapshot.value as? [String:[String:String]] ?? ["":[:]]
        //    print(pulleduserdata)
        //    print(snapshot)
            
        }
        
       // print(newString)
        //WORKS ------ does not use random key and uses the users email as the random key
        //looks within database SIM then looks for key newString which is email, put the values in a saved constant
        ref.child("userDataByEmail").child("b@b_com").observe(DataEventType.value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String:[String:String]] ?? ["":[:]]
            //print(pulleduserdata)
           // print(snapShot)
            
            //pulleduserdata.isEmpty
            
           // self.nickName = pulleduserdata["userNickName"] ?? ""
          //  self.email = pulleduserdata["playerEmail"] ?? ""
          //  self.cash = pulleduserdata["gameInProgress"] ?? ""
            
          //  print(self.nickName)
          //  print(self.email)
          //  print(self.cash)
            
            
            }
            
        // update the database without making complete or rewrite of all data
        let updates = ["":""]
        /*MARK: - updating
        ref.child("SIMPlayerScores/\(newString))").updateChildValues(userDetailsTwo){(Error, ref) in
            if let error = Error {
                print("An error happened:\(error)")
            }else{
                print("data saved successfully")
            }
            
        }
 
 */
        //how do i remove handles?
       //ref.removeObserver(withHandle: DatabaseHandle.)
 

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

