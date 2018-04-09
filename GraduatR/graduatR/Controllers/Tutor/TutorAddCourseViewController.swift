//
//  TutorAddCourseViewController.swift
//  graduatR
//
//  Created by Dhriti Chawla on 3/22/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Firebase

class TutorAddCourseViewController: UIViewController {

    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var info: UILabel!
    var n = String()
    var list = String()
    var sa = String()
    var name = AllVariables.Fname
    var lastName = AllVariables.Lname
    var GPA = AllVariables.GPA
    var user = AllVariables.Username
    var Class = AllVariables.standing
    var ref: DatabaseReference!
    var c = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if (!AllVariables.courses.contains(n)){
            button.setTitle("Add course", for: UIControlState.normal)
        }
        else {
            button.setTitle("Remove course", for: UIControlState.normal)
        }
        
        courseName.text = n
        info.text = c
        ref = Database.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressedAddButton(_ sender: Any) {
        
        print(AllVariables.Username)
        print(n)
        print(button.currentTitle)
        
        
        //if (button.currentTitle! == "Add course") {
        
        if (!AllVariables.courses.contains(n)){
            let c = "Course\(AllVariables.courses.endIndex)"
            
            AllVariables.courses.append(n)
            
            ref.child("Users").child("Tutor").child(AllVariables.uid).child("Courses").child(c).setValue(n)
            
            //adding tutor to tutor list
            print(sa)
            
            let size = AllVariables.courses.endIndex
            list.removeAll()
            if (size != 0) {
                print (AllVariables.courses)
                var  i = 0;
                
                while (i < size){
                    list += "\n \(AllVariables.courses[i])"
                    i += 1
                }
                
            }
            ref.child("TutorList").child(self.sa).child(AllVariables.Username).setValue(["Fname": AllVariables.Fname, "Lname": AllVariables.Lname, "Bio": AllVariables.bio, "Courses": list ])
            
            
            button.setTitle("Remove course", for: UIControlState.normal)
            
            print (AllVariables.courses)
            
            let alert = UIAlertController(title: "YAY!", message: "Course added to your profile!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print ("ok tappped")
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true) {
                print("added course")
            }
        }
        else {
            
            let i = AllVariables.courses.index(of: n)
            AllVariables.courses.remove(at: i!)
            
            var index = 0
            ref.child("Users").child("Tutor").child(AllVariables.uid).child("Courses").setValue([])
        
            
            while (index < AllVariables.courses.endIndex) {
                let c = "Course\(index)"
                ref.child("Users").child("Tutor").child(AllVariables.uid).child("Courses").child(c).setValue(AllVariables.courses[index])
                index += 1
                
            }
            
            print (n)
            button.setTitle("Add course", for: UIControlState.normal)
            let alert = UIAlertController(title: "OOPS!", message: "Course removed from your profile!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print ("ok tappped")
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true) {
                print("removed course")
            }
            //
        }
        
        
    }
    
    
}
