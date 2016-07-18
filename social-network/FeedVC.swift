//
//  FeedVC.swift
//  social-network
//
//  Created by Kevin Amiranoff on 17/07/2016.
//  Copyright © 2016 Kevin Amiranoff. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var tableView:UITableView!
  @IBOutlet weak var postField: MaterialTextField!
  @IBOutlet weak var imageSelector: UIImageView!
  
  
  var imagePicker:UIImagePickerController!
  var imageSelected = false
  
  var posts = [Post]()
  
  
  
  static var imageCache = NSCache()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.estimatedRowHeight = 318
    
    
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    
    DataService.ds.REF_POSTS.observeEventType(.Value, withBlock:  { snapshot in
      
      
      self.posts = []
      
      if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
        for snap in snapshots {
            //print(snap)
          
          if let postDict = snap.value as? Dictionary<String,AnyObject> {
            let key = snap.key
            let post = Post(postKey: key, dictionary: postDict)
            self.posts.append(post)
            
          }
        }
      }
      
      self.tableView.reloadData()
      
    })
    
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
      cell.request?.cancel()
      
      let post = self.posts[indexPath.row]
      var img:UIImage?
      
      if let url = post.imageUrl {
        img = FeedVC.imageCache.objectForKey(url) as? UIImage
      }
      
      cell.configureCell(post,img:img)
      return cell
    }
    
    return PostCell()
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let post = posts[indexPath.row]
    
    if post.imageUrl == nil {
      return ROW_WITHOUT_IMAGE_HEIGHT
    }else {
      return tableView.estimatedRowHeight
    }
  }
  
  
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    imagePicker.dismissViewControllerAnimated(true, completion: nil)
    imageSelector.image = image
    imageSelected = true
  }
  
  @IBAction func selectImage(sender: UITapGestureRecognizer) {
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func makePost(sender: AnyObject) {
    
    if let txt = postField.text where txt != "" {
      
      if let img = imageSelector.image where imageSelected == true {
        
        let urlString = "https://post.imageshack.us/upload_api.php"
        let url = NSURL(string: urlString)!
        let imgData = UIImageJPEGRepresentation(img, 0.2)!
        let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
        let keyJson = "json".dataUsingEncoding(NSUTF8StringEncoding)!
        
        Alamofire.upload(.POST,url, multipartFormData: { multipartFormData in
          
          multipartFormData.appendBodyPart(data:imgData,name:"fileupload",fileName:"image",mimeType: "image/jpg")
          multipartFormData.appendBodyPart(data:keyData,name:"key")
          multipartFormData.appendBodyPart(data:keyJson,name:"format")
          
          
        }) { encodingResult in
          switch encodingResult {
          case .Success(let upload,_,_):
            
            upload.responseJSON(completionHandler: { response in
              
              
              switch response.result {
              case .Success:
                if let links = response.result.value!["links"] as? Dictionary<String,AnyObject> {
                  if let imgLink = links["image_link"] as? String {
                    print(String("LINK: \(imgLink)"))
                    self.postToFirebase(imgLink)
                  }
                }
                
              case .Failure(let error):
                print(error)
              }
              
            })
            
            
            
          case .Failure(let error):
            print(error)
          }
        }
      }else{
        self.postToFirebase(nil)
      }
    }
    
  }
  
  func postToFirebase(imgUrl:String?)  {
    var post:Dictionary<String,AnyObject> = [
      "description":postField.text!,
      "likes":0
    ]
    if imgUrl != nil {
      post["imageUrl"] = imgUrl!
    }
    
    let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
    firebasePost.setValue(post)
  
    postField.text = ""
    imageSelector.image = UIImage(named: "photo-camera")
    imageSelected = false
    tableView.reloadData()
  }
  
  
}






