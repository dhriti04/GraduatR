//
//  CreateGroupViewController.swift
//  graduatR
//
//  Created by Dhriti Chawla on 4/16/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var names = [String]()
    let searchBar = UISearchBar()
    var filteredArrayName = [String]()
    var showSearchResults = false
    var selectednames = [String]()
    @IBOutlet weak var createbutton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var firstnames = [String]()
    @IBOutlet weak var groupname: UITextField!
    @IBAction func create(_ sender: Any) {
        var a = 0
        print(selectednames)
        if (groupname.text == "") {
            let alert = UIAlertController(title: "Error", message: "Group name cannot be empty!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print ("ok tappped")
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true) {
                print("ERROR")
            }
            print("error creating group")
        }
        else {
            Database.database().reference().child("GroupChats").observeSingleEvent(of: DataEventType.value, with: { (snap) in
                if (snap.hasChild(self.groupname.text!)) {
                    let alert = UIAlertController(title: "Error", message: "Group name is taken!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print ("ok tappped")
                    }
                    alert.addAction(OKAction)
                    self.present(alert, animated: true) {
                        print("ERROR")
                    }
                    print("error group create")
                }
                else {
                    for nam in self.selectednames {
                        Database.database().reference().child("GroupChats").child(self.groupname.text!).child("chatUsers").child(nam).setValue(self.firstnames[self.names.index(of: nam)!])
                        Database.database().reference().child("Chats").child(nam).child(self.groupname.text!).child("GC").setValue("value")
                        
                    }
                    
                   
                    let myname = "\(AllVariables.Fname) \(AllVariables.Lname)"
                    Database.database().reference().child("GroupChats").child(self.groupname.text!).child("chatUsers").child(AllVariables.Username).setValue(myname)
                }
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    override func viewDidLoad() {
        selectednames.removeAll()
        createSearchBar()
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        getallusers()
}
    func getallusers() {
        Database.database().reference().child("Users").child("StudentUsers").observeSingleEvent(of: DataEventType.value, with: { (s) in
            let val = s.value as? NSDictionary
            self.names = val?.allKeys as! [String]
            self.firstnames = val?.allValues as! [String]
            print(self.names)
            self.tableView.reloadData()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (showSearchResults) {
            return filteredArrayName.count
        } else {
            return self.names.count
        }
    }
    
    func createSearchBar() {
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search your friend...."
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let mySearch = searchBar.text!
        filteredArrayName = names.filter({( name: String) -> Bool in
            return name.lowercased().range(of:searchText.lowercased()) != nil
        })
        if searchBar.text == "" {
            showSearchResults = false
            self.tableView.reloadData()
        } else {
            showSearchResults = true
            self.tableView.reloadData()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearchResults = true
        searchBar.endEditing(true)
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatUsersCell", for: indexPath) as! GroupChatUsersCell
        if (showSearchResults){
            let nam = filteredArrayName[indexPath.row]
            cell.name.text = nam
            
            let selectedIndexPaths = tableView.indexPathsForSelectedRows
            let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
            cell.accessoryType = rowIsSelected ? .checkmark : .none
            // cell.accessoryView.hidden = !rowIsSelected
            // if using a custom image
        } else {
        
        let nam = names[indexPath.row]
        cell.name.text = nam
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        // cell.accessoryView.hidden = !rowIsSelected
        // if using a custom image
        }
        
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        if (showSearchResults) {
            if (!selectednames.contains(filteredArrayName[indexPath.row])) {
                selectednames.append(filteredArrayName[indexPath.row])
            }
            else {
                cell.accessoryType = .none
                let a = selectednames.index(of: filteredArrayName[indexPath.row])
                selectednames.remove(at: a!)
            }
        }
        else {
            if (!selectednames.contains(names[indexPath.row])) {
                selectednames.append(names[indexPath.row])
            }
            else {
                cell.accessoryType = .none
                let a = selectednames.index(of: names[indexPath.row])
                selectednames.remove(at: a!)
            }
        }
        // cell.accessoryView.hidden = false // if using a custom image
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        if (showSearchResults) {
            let a = selectednames.index(of: filteredArrayName[indexPath.row])
            selectednames.remove(at: a!)
        }
        else {
            let a = selectednames.index(of: names[indexPath.row])
            selectednames.remove(at: a!)
        }
        // cell.accessoryView.hidden = true  // if using a custom image
    }
    
    
//    When you're done, get an array of all the selected rows
    
//    let selectedRows = tableView.indexPathsForSelectedRows
//    and get the selected data, where dataArray maps to the rows of a table view with only 1 section
//
//    let selectedData = selectedRows?.map { dataArray[$0.row].ID }

}

