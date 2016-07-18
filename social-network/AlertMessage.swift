//
//  AlertMessage.swift
//  social-network
//
//  Created by Kevin Amiranoff on 17/07/2016.
//  Copyright © 2016 Kevin Amiranoff. All rights reserved.
//

import Foundation
import UIKit

class AlertMessage {
  
  
  func showErrorAlert(title:String,msg:String) {
    let alert = UIAlertController(title: title,message: msg,preferredStyle: .Alert)
    let action = UIAlertAction(title: "Ok",style: .Default,handler: nil)
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
  }
  
}