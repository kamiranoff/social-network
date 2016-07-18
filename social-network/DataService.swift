//
//  DataService.swift
//  social-network
//
//  Created by Kevin Amiranoff on 16/07/2016.
//  Copyright © 2016 Kevin Amiranoff. All rights reserved.
//

import Foundation
import Firebase



class DataService {
  
  static let ds = DataService()
  
  private var _REF_BASE = URL_BASE
 
  private var _REF_POSTS = URL_BASE.child("posts")
  private var _REF_USERS = URL_BASE.child("users")
  
  
  var REF_BASE:FIRDatabaseReference{
    return _REF_BASE
  }
  
  var REF_POSTS:FIRDatabaseReference{
    return _REF_POSTS
  }
  
  var REF_USERS:FIRDatabaseReference{
    return _REF_USERS
  }
  
  var REF_CURRENT_USER: FIRDatabaseReference {
    let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
    let user = URL_BASE.child("users").child(uid)
    return user
  }
  
  
  func createFirebaseUser(uid:String,user:Dictionary<String,String>){
    REF_USERS.child(uid).updateChildValues(user)
  
  }
}



