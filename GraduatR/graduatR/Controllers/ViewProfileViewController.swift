//
//  ViewProfileViewController.swift
//  graduatR
//
//  Created by Harika Lingareddy on 2/20/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewProfileViewController: UIViewController
{
    
    @IBOutlet weak var myCourses: UILabel!
    var list = String()
    var loggedInUser: AnyObject?
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var image: UIImageView!
    
    @IBOutlet weak var pictureonprofilepage: UIImageView!
    @IBOutlet weak var updateBioText: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //pictureonprofilepage = image
        nameLabel.text = AllVariables.Fname + " " + AllVariables.Lname
        self.navigationItem.title = AllVariables.Username
        //updateBioText.text = AllVariables.bio
        
        myCourses.text = "No courses added!"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateBioText.text = AllVariables.bio
        pictureonprofilepage = image
        
        let size = AllVariables.courses.endIndex
        if (size != 0) {
            var  i = 0;
            while (i < size){
                list += "\n \(AllVariables.courses[i])"
                i += 1
            }
            myCourses.text = list
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


