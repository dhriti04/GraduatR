//
//  SubjectViewController.swift
//  graduatR
//
//  Created by Dhriti Chawla on 3/8/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate {

    
    @IBOutlet var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    var courseData = [[String: AnyObject]]()
    var subjects = [String]()
    var subID = [String]()
    
    var filteredArrayName = [String]()
    //   var filteredArrayNumber = [String]()
    var showSearchResults = false
    
    var refresh: UIRefreshControl!
    
    func fetchData () {
        
        let url:String = "https://api.purdue.io/odata/Subjects"
        let urlRequest = URL(string: url)
        
        if let URL = urlRequest {
            let task = URLSession.shared.dataTask(with: URL) { (data, response, error) in
                if (error != nil) {
                    print ("============")
                    print (error?.localizedDescription)
                } else {
                    if let stringData = String(data: data!, encoding: String.Encoding.utf8) {
    
                        //print (stringData)
                        do {
                            if let data = data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let value = json["value"] as? [[String: Any]] {
                                for val in value {
                                    var currSubId = val["SubjectId"] as! String
                                    self.subID.append(currSubId)
                                        
                                        if let name = val["Abbreviation"] as? String {
                                            
                                            self.subjects.append(name)
                                            
                                          
                                        }
                                        self.collectionView.reloadData()
                                    
                                }
                            }
                            
                            
                            self.refresh.endRefreshing()
                        } catch {
                            print ("Error is : \(error)")
                        }
                    }
                }
                
            }; task.resume()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createSearchBar()
        
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(SubjectViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        collectionView.insertSubview(refresh, at: 0)
        
        collectionView.reloadData()
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSearchBar() {
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search a subject...."
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearchResults = true
        searchBar.endEditing(true)
        
        self.collectionView.reloadData()
    }
    
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let mySearch = searchBar.text!
        filteredArrayName = subjects.filter({( name: String) -> Bool in
            return name.lowercased().range(of:searchText.lowercased()) != nil
        })
        
        
        if searchBar.text == "" {
            showSearchResults = false
            self.collectionView.reloadData()
        } else {
            showSearchResults = true
            self.collectionView.reloadData()
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (showSearchResults) {
            return filteredArrayName.count
        }
        else {
          print(subjects.count)
        return subjects.count
        }
        
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        
        print(subjects)
        
        if (showSearchResults){
            
            let nam = filteredArrayName[indexPath.row]
            cell.sub!.text = nam
            
        }
        else {
            let nam = subjects[indexPath.row]
            cell.sub!.text = nam
        }
        return cell
    }
    


}
