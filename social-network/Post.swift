//
//  Post.swift
//  social-network
//
//  Created by Kevin Amiranoff on 18/07/2016.
//  Copyright © 2016 Kevin Amiranoff. All rights reserved.
//

import Foundation
import Firebase

class Post {
  private var _postDescription: String!
  private var _postImageUrl: String?
  private var _postLikes: Int!
  private var _username:String!
  private var _postKey:String!
  private var _postRef:FIRDatabaseReference!
  
  var postDescription:String {
    return _postDescription
  }
  
  var imageUrl:String? {
    return _postImageUrl
  }
  
  var likes:Int {
    return _postLikes
  }
  
  var username:String {
    return _username
  }
  
  var postKey:String {
    return _postKey
  }
  
  init(description:String,imageUrl:String?,username:String) {
    self._postDescription = description
    self._postImageUrl = imageUrl
    self._username = username
  }
  
  init(postKey:String, dictionary:Dictionary<String,AnyObject>) {
    self._postKey = postKey
    
    if let likes = dictionary["likes"] as? Int {
      self._postLikes = likes
    }
    
    if let imgUrl = dictionary["imageUrl"] as? String {
      self._postImageUrl = imgUrl
    }
    
    if let desc = dictionary["description"] as? String {
      self._postDescription = desc
    }
    
    self._postRef = DataService.ds.REF_POSTS.child(self.postKey)
    
  }
  
  func adjustLikes(addLikes:Bool){
    if addLikes{
      _postLikes = _postLikes + 1
    }else{
      _postLikes = _postLikes - 1
    }
    _postRef.child("likes").setValue(_postLikes)
  }
}




