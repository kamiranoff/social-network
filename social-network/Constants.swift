//
//  Constants.swift
//  social-network
//
//  Created by Kevin Amiranoff on 15/07/2016.
//  Copyright © 2016 Kevin Amiranoff. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//url
let FIREBASE_URL:String = "https://social-network-test-34dcf.firebaseio.com/"
let URL_BASE = FIRDatabase.database().reference()

//keys
let KEY_UID = "uid"

//others
let SHADOW_COLOR:CGFloat = 157.0 / 255.0
let ROW_WITHOUT_IMAGE_HEIGHT:CGFloat = 220.0

//SEGUES
let SEGUE_LOGGED_IN = "loggedIn"


//Status Codes
let STATUS_BAD_EMAIL = 17008
let STATUS_ACCOUNT_NONEXIST = 17011