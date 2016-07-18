//
//  PostCell.swift
//  social-network
//
//  Created by Kevin Amiranoff on 17/07/2016.
//  Copyright © 2016 Kevin Amiranoff. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class PostCell: UITableViewCell {
  
  @IBOutlet weak var profileImg:UIImageView!
  @IBOutlet weak var showcaseImg:UIImageView!
  @IBOutlet weak var descriptionText: UITextView!
  @IBOutlet weak var likesLbl:UILabel!
  @IBOutlet weak var likeImg:UIImageView!

  var post: Post!
  var request:Request?
  var likeRef:FIRDatabaseReference!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
    tap.numberOfTapsRequired = 1;
    likeImg.addGestureRecognizer(tap)
    likeImg.userInteractionEnabled = true
  }
  
  override func drawRect(rect: CGRect) {
    profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
    profileImg.clipsToBounds = true
    showcaseImg.clipsToBounds = true
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
      // Configure the view for the selected state
  }
  
  func configureCell(post:Post,img:UIImage?) {
    self.showcaseImg.image = nil
    
    self.likeRef = DataService.ds.REF_CURRENT_USER.child("likes").child(post.postKey)
    
    self.post = post
    self.descriptionText.text = post.postDescription
    self.likesLbl.text = "\(post.likes)"
    
    if post.imageUrl != nil {
      
      if img != nil {
        
        showcaseImg.image = img!
      }else {
        request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data,error in
          if error == nil {
            
            
            let img = UIImage(data:data!)!
            self.showcaseImg.image = img
            FeedVC.imageCache.setObject(img, forKey: self.post!.imageUrl!)
            
          }else{
            print(error.debugDescription)
          }
        })
      }
      
    }else {
      //self.showcaseImg.hidden = true
    }
    
    likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
      if let doesNotExist = snapshot.value as? NSNull {
        self.likeImg.image = UIImage(named: "heart-grey" )
      }else{
        self.likeImg.image = UIImage(named: "heart-full")
      }
    })
    
  }
  
  func likeTapped(sender:UIGestureRecognizer) {
    likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
      if let doesNotExist = snapshot.value as? NSNull {
        self.likeRef.setValue(true)
        self.likeImg.image = UIImage(named: "heart-full")
        self.post.adjustLikes(true)
       
      }else{
        self.likeRef.removeValue()
        self.likeImg.image = UIImage(named: "heart-grey" )
        self.post.adjustLikes(false)
        
      }
      self.likesLbl.text = "\(self.post!.likes)"

    })
  }

}



