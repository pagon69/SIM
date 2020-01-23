//
//  LoginPage.swift
//  SIM
//
//  Created by user147645 on 7/30/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
//import Alamofire
import GoogleSignIn
import FBSDKLoginKit
import SVProgressHUD


class LoginPage: UIViewController, UITextFieldDelegate, GIDSignInDelegate {
    
    var variousSymbols = [JsonSerial]()
    
    //google sign in action
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        print("\n\n\n/n/n/n this is a test \n\n\n\n/n/n/n/n")
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            print(" \n\n\n\n/n/n/n  this is within signin n\n\n\n\\n/n/n/n/n")
            self.performSegue(withIdentifier: "goToOverviewPage", sender: self)
            
            
        }

        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
   
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            
            //return GIDSignIn.sharedInstance().handle(url)
            
            // let checkFB = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            // let checkGoogle = GIDSignIn.sharedInstance().handle(url as URL!,sourceApplication: sourceApplication,annotation: annotation)
            
            // let checkFB = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            let checkFB = false
            let checkGoogle = GIDSignIn.sharedInstance().handle(url)
            
            return checkGoogle || checkFB
            
            
            
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    // for legacy ios devices and google sign in
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // return true
        
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    //MARK: - IBActions
    @IBOutlet weak var signInErrorButtonOutlet: UIButton!
    
    @IBOutlet weak var userprovidedEmail: UITextField!
    @IBOutlet weak var userProvidedPassword: UITextField!
    
    @IBOutlet weak var errorMsgOutlet: UILabel!
    //shows the secure text or hides it
    @IBAction func showOrHideButton(_ sender: UIButton) {
        userProvidedPassword.isSecureTextEntry = !userProvidedPassword.isSecureTextEntry
    }
    
    
    @IBOutlet weak var FBSignInOutlet: FBLoginButton!
    
    
    @IBOutlet weak var GoogleSignInOutlet: GIDSignInButton!
    
    /*I made this button is it needed
    @IBAction func GoogleSigninButtonClicked(_ sender: GIDSignInButton) {
        
        
    }
    */
    
    func errorAnimation(){
        
        //allows for multiple optiosn including repeat
        UIView.animate(withDuration: 5.0, delay: 0, options: [.curveEaseIn], animations: {
            self.signInErrorButtonOutlet.transform = CGAffineTransform(rotationAngle: -90.0)
            
            
        }) { (results) in
           // self.signInErrorButtonOutlet.transform = CGAffineTransform(rotationAngle: -60.0)
        }
        
    }
    
    
    @IBAction func SignInButton(_ sender: UIButton) {
        //if the user types something into username and password
        
        SVProgressHUD.show()
        var validate = false
        
        if let username = userprovidedEmail.text, let psw = userProvidedPassword.text{
            
            if username == "" && psw == ""{
                errorMsgOutlet.text = "Invalidate password/Username combination"
                errorMsgOutlet.textColor = UIColor.red
                errorMsgOutlet.isHidden = false
                SVProgressHUD.dismiss()
                
            }else if psw == "" {
                errorMsgOutlet.text = "Please enter a password"
                errorMsgOutlet.textColor = UIColor.red
                errorMsgOutlet.isHidden = false
                SVProgressHUD.dismiss()
                //errorAnimation()
                
            }else if username == "" {
                errorMsgOutlet.text = "please enter a validate email address"
                errorMsgOutlet.textColor = UIColor.red
                errorMsgOutlet.isHidden = false
                SVProgressHUD.dismiss()
                
            }else {
                
                for letter in username {
                    if letter == "@"{
                        validate = true
                    }else{
                        //errorMsgOutlet.text = "please enter a validate email address"
                       // errorMsgOutlet.textColor = UIColor.red
                       // errorMsgOutlet.isHidden = false
                    }
                }
            }
            
                    if validate {
                        
                                //progressHUD.show
                        Auth.auth().signIn(withEmail: username, password: psw) { (FBResults, error) in
                            
                            if error == nil{
      
                                self.performSegue(withIdentifier: "goToOverviewPage", sender: self)
                                SVProgressHUD.dismiss()
                                
                            }else {
                               
                                SVProgressHUD.dismiss()

                                let cleanError = error.debugDescription
                            
                                var newError :[Character] = []
                                for letter in cleanError{
                                    newError.append(letter)
                                }

                                let answer = newError.split(separator:"\"")
                                var bestAnswer = ""
                                
                                for each in answer[1]{
                                    bestAnswer = bestAnswer + String(each)
                                }

                                self.errorMsgOutlet.text = bestAnswer
                                self.errorMsgOutlet.textColor = UIColor.red
                                self.errorMsgOutlet.isHidden = false
                                //progressHUD.dismiss
                            }
                            
                        }
                        
                    }
        }
    }

    func getSymbols(){
        //list of all symbols
        let defaultURL = "https://api.iextrading.com/1.0/ref-data/symbols"
        let session = URLSession.shared
        let url = URL(string: defaultURL)
        //setup and use a response/request handler for http with json
        let task = session.dataTask(with: url!) { (data, response, error) in
            //checks for client and basic connection errors
            if error != nil || data == nil {
                print("An error happened on the client side, \(error)")
                return
            }
            //checks for server side issues
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                else {
                    print ("server error")
                    return
            }
            //checks for mime or serialization errors
            guard let mime = response.mimeType, mime == "application/json"
                else{
                    print("mime type error check spelling or type")
                    return
            }
            //working on codable?
            do {
                let myResults = try! JSONDecoder().decode([JsonSerial].self, from: data!)
                self.variousSymbols = myResults

                if data != nil {
                    print("collected the data successfully")
                }
            }catch {
                print("JSON error", error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        let destVC = segue.destination as! OverviewPage
        destVC.passedSymbolsInfo = variousSymbols
        
    }
    
    
    
    @IBAction func RegisterButton(_ sender: UIButton) {
        //currently just a direct segue nothing by code
        
        //SVProgressHUD can spin now
        
    }
    
    
    @IBAction func Terms(_ sender: UIButton) {
        
        //currently just a direct segue nothing by code
        
        //SVProgressHUD can spin now, disable with SVProgressHUD.disable within the viewill Appear of upcoming view
        
    }
    
    //MARK: - Views for animation
    
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    @IBOutlet weak var botViewOutlet: UIView!
    

    //MARK: - keyboard tracking stuff
    //removes keyboard so i can see full screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
    /* enables login if content is within username/password buttons
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (usernameOutlet.text?.isEmpty == false && userPwdOutlet.text?.isEmpty == false ){
            
            loginOutlet.isEnabled = true
        }
        
    }
    
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //Mark: - View did load

    override func viewDidLoad() {
        super.viewDidLoad()

            viewSetup()
          //  getSymbols()
            getSymbols()
        
    }
    
    
    
    
    //MARK: viewSetup - gets the view ready to go
    func viewSetup(){
        topViewOutlet.alpha = 0
        errorMsgOutlet.isHidden = true
        
        userprovidedEmail.layer.cornerRadius = 20
        userprovidedEmail.layer.masksToBounds = true
        
        userProvidedPassword.layer.masksToBounds = true
        userProvidedPassword.layer.cornerRadius = 20
        
        GoogleSignInOutlet.layer.cornerRadius = 20
        GoogleSignInOutlet.layer.masksToBounds = true
       // GoogleSignInOutlet.colorScheme = .light
        GoogleSignInOutlet.style = .wide
        
   
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance()?.signIn()
        
        //let loginButton = FBLoginButton()
        //FBSignInOutlet.delegate = self
    }
    
    //MARK: - Animates and rounds the corners on views
    func animationSetup(){
        
        UIView.animate(withDuration: 3.0) {
            self.topViewOutlet.alpha = 1
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationSetup()
    }

}
