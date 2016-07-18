//
//  ViewController.swift
//  social-network
//
//  Created by Kevin Amiranoff on 15/07/2016.
//  Copyright © 2016 Kevin Amiranoff. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


class ViewController: UIViewController {

  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
       print(DataService.ds.REF_BASE)
    
  }

  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
     self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    }
  }
  

  @IBAction func fbBtnPressed(sender:UIButton){
    let facebookLogin = FBSDKLoginManager()
    
    
    facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult:FBSDKLoginManagerLoginResult!, facebookErr:NSError!) in
      
      if facebookErr != nil {
        print("Facebook login failed \(facebookErr)")
      }else {
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
        print("Successfully logged in with Facebook. \(accessToken)")
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
          if error != nil {
            print("Login failed - \(error)")
          }else{
            print("Logged in with \(user)")
            
            //Saving to db
            let uid = user!.uid
            let userData = ["provider":credential.provider]
            DataService.ds.createFirebaseUser(uid, user: userData)
            
            
            NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
          }
        }
      }
    }
  }

  @IBAction func attemptLogin(sender:UIButton!){
    if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
      
      FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user,error) in
        
        if error != nil {
          print(error!)
          
          if error!.code == STATUS_ACCOUNT_NONEXIST && error!.code != STATUS_BAD_EMAIL {
            
            FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
              if error != nil {
                print(error)
                self.showErrorAlert("Cannot create account", msg: "Try something else")
              }else {
                
                NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                //FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user, error) in
//                  if error != nil {
//                    print(error!)
//                  }else{
//                    print("HERE!")
//                    
                    //Saving to db
                    let uid = user!.uid
                    let userData = ["provider": "email"]
                    DataService.ds.createFirebaseUser(uid, user: userData)
                    
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                   
                  }
  //              })
  //            }
            })
            
          }else{
            self.showErrorAlert("Cannot create account", msg: "Try something else")
          }
          
        }
        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
      })
      
    }else {
      showErrorAlert("Email and password are required", msg: "You must enter an email and a password")
    }
  }
  
  func showErrorAlert(title:String,msg:String) {
    let alert = UIAlertController(title: title,message: msg,preferredStyle: .Alert)
    let action = UIAlertAction(title: "Ok",style: .Default,handler: nil)
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
  }
}






