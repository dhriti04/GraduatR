//
//  ParentReviewViewController.swift
//  graduatR
//
//  Created by Dhriti Chawla on 3/24/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Firebase
import Charts

class ParentReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var avgrating = Double()
    var ref = Database.database().reference()
    @IBOutlet weak var pieChartView: PieChartView!
    let stars = ["One", "Two", "Three", "Four", "Five"]
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var average: UILabel!
    
    var reviews = [String]()
    var usernames = [String]()
    
     var gradesAvg = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
        getData2()
        getfunc()
    }
    func getfunc() {
        ref.child("CourseReviews").child(AllVariables.courseselected).child("Comments").observeSingleEvent(of: DataEventType.value, with: { (snapshotA) in
            
            print("before")
            let enumer = snapshotA.children
            while let rest = enumer.nextObject() as? DataSnapshot {
                
                let snap = rest.value as! NSDictionary
                if (snap["Anonymity"] as! String! == "yes") {
                    let review = snap["reviews"] as! String
                    if (!(self.reviews.contains("Anonymous: \(review)"))) {
                        self.usernames.append("@anonymous")
                        self.reviews.append("\(review)")
                    }
                    
                }
                else {
                    let review = snap["reviews"] as! String
                    if (!(self.reviews.contains("\(rest.key as! NSString): \(review)"))) {
                        self.usernames.append("@\(rest.key as NSString)")
                        self.reviews.append("\(review)")
                    }
                }
            }
            print("After")
            
            print("After")
            
            self.tableView.reloadData()
            self.tableView.delegate = self
            self.tableView.dataSource = self
        })
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        getdata()
        getData2()
        getfunc()
    }
    
    func getdata() {
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshotA) in
            print("WHAT3")
            if (!(snapshotA.hasChild("CourseReviews"))) {
                self.ref.child("CourseReviews").child(AllVariables.courseselected).setValue(["1stars": 0, "2stars": 0, "3stars": 0, "4stars": 0, "5stars": 0 ])
                
                AllVariables.courseratings = [0, 0, 0, 0, 0]
                self.setChart(dataPoints: self.stars, values: AllVariables.courseratings)
                
            }
            else {
                self.ref.child("CourseReviews").observeSingleEvent(of: DataEventType.value, with: { (snapshotB) in
                    print("WHAT4")
                    if (!(snapshotB.hasChild(AllVariables.courseselected))) {
                        self.ref.child("CourseReviews").child(AllVariables.courseselected).setValue(["1stars": 0, "2stars": 0, "3stars": 0, "4stars": 0, "5stars": 0 ])
                        
                        
                        AllVariables.courseratings = [0, 0, 0, 0, 0]
                        self.setChart(dataPoints: self.stars, values: AllVariables.courseratings)
                        
                        
                    }
                    else {
                        self.ref.child("CourseReviews").child(AllVariables.courseselected).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                            let valu = snapshot.value as? NSDictionary
                            print("IMHERE")
                            let n1 = valu?["1stars"] as? Double
                            let n2 = valu?["2stars"] as? Double
                            let n3 = valu?["3stars"] as? Double
                            let n4 = valu?["4stars"] as? Double
                            let n5 = valu?["5stars"] as? Double
                            
                            let sum = (n1! * 1.0) + (n2! * 2.0) + (n3! * 3.0) + (n4! * 4.0) + (n5! * 5.0)
                            print("SUM \(sum)")
                            self.avgrating = (sum)/(n1!+n2!+n3!+n4!+n5!)
                            print("AVG RATING = \(self.avgrating)")
                            
                            self.average.text = "Average rating: \(self.avgrating)"
                            AllVariables.courseratings = [n1!, n2!, n3!, n4!, n5!]
                            print("THIS: \(AllVariables.courseratings)")
                            self.setChart(dataPoints: self.stars, values: AllVariables.courseratings)
                        })
                    }
                })
                
            }
            
        })
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            print("THIS: \(AllVariables.courseratings)")
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            if (values[i] != 0.0) {
                dataEntries.append(dataEntry1)
            }
        }
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Number of Stars")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }
    
    func tableView(_ tableView:UITableView!, numberOfRowsInSection section:Int) -> Int
    {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseReviewCell", for: indexPath) as! CourseReviewCell
        
        let review = reviews[indexPath.row]
        let uname = usernames[indexPath.row]
        print("PARENT USERNAME THING")
        print(uname)
        //cell.userLabel.text = uname
        cell.reviewText.text = review
        
        return cell
    }
    
    func getData2() {
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshotA) in
            print("WHAT3")
            if (!(snapshotA.hasChild("AllCourseGrades"))) {
                self.ref.child("AllCourseGrades").child(AllVariables.courseselected).setValue(["A+": 0, "A": 0, "A-": 0, "B+": 0, "B": 0, "B-": 0, "C+": 0, "C": 0, "C-": 0, "D+": 0, "D": 0, "D-": 0, "F": 0])
                
                AllVariables.coursegrade = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                self.setChart2(dataPoints: self.gradesAvg, values: AllVariables.coursegrade)
                
            }
            else {
                self.ref.child("AllCourseGrades").observeSingleEvent(of: DataEventType.value, with: { (snapshotB) in
                    print("WHAT4")
                    if (!(snapshotB.hasChild(AllVariables.courseselected))) {
                        self.ref.child("AllCourseGrades").child(AllVariables.courseselected).setValue(["A+": 0, "A": 0, "A-": 0, "B+": 0, "B": 0, "B-": 0, "C+": 0, "C": 0, "C-": 0, "D+": 0, "D": 0, "D-": 0, "F": 0])
                        
                        
                        AllVariables.coursegrade = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                        self.setChart2(dataPoints: self.gradesAvg, values: AllVariables.coursegrade)
                        
                        
                    }
                    else {
                        self.ref.child("AllCourseGrades").child(AllVariables.courseselected).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                            let valu = snapshot.value as? NSDictionary
                            print("IMHERE")
                            let n1 = valu?["A+"] as? Double
                            let n2 = valu?["A"] as? Double
                            let n3 = valu?["A-"] as? Double
                            let n4 = valu?["B+"] as? Double
                            let n5 = valu?["B"] as? Double
                            let n6 = valu?["B-"] as? Double
                            let n7 = valu?["C+"] as? Double
                            let n8 = valu?["C"] as? Double
                            let n9 = valu?["C-"] as? Double
                            let n10 = valu?["D+"] as? Double
                            let n11 = valu?["D"] as? Double
                            let n12 = valu?["D-"] as? Double
                            let n13 = valu?["F"] as? Double
                            
                            
                            //let sum = (n1! * 1.0) + (n2! * 2.0) + (n3! * 3.0) + (n4! * 4.0) + (n5! * 5.0)
                            
                            //self.avgrating = (sum)/(n1!+n2!+n3!+n4!+n5!)
                            
                            // self.average.text = "Average rating: \(self.avgrating)"
                            AllVariables.coursegrade = [n1!, n2!, n3!, n4!, n5!, n6!, n7!, n8!, n9!, n10!, n11!, n12!, n13!]
                            print(AllVariables.coursegrade)
                            
                            self.setChart2(dataPoints: self.gradesAvg, values: AllVariables.coursegrade)
                        })
                    }
                })
                
            }
            
        })
    }
    
    func setChart2(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let barDataSet = BarChartDataSet(values: dataEntries, label: "units")
        let barData = BarChartData(dataSet: barDataSet)
        barChartView.data = barData
        
    }
    
    
    

}
