//
//  PurityListViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/23/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class PurityListViewController: UITableViewController {
    
    private typealias `Self` = PurityListViewController
    static var purityReports: [[Int: Dictionary<String, Any>]] = []
    var selectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Self.purityReports.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purityCell", for: indexPath)
        let reportNum = Self.purityReports[indexPath.row].keys.first!
        let reporter = String(describing: (Self.purityReports[indexPath.row][indexPath.row + 1]?["reporter"])!)
        let report = Self.purityReports[indexPath.row][indexPath.row + 1]! as Dictionary<String, AnyObject>
        let date = (report["date"]!), weekdayNum = date["weekday"]!!, monthNum = date["months"]!!, theDate = date["date"]!!, hour = date["hours"]!!, minute = date["minutes"]!!, second = date["seconds"]!!, year = date["year"]!!
        let weekday = getWeekDay(num: weekdayNum as! Int)
        let month = getMonth(num: monthNum as! Int)
        let label = "Report #\(reportNum) submitted by \(reporter) on \(weekday) \(month) \(theDate) \(hour):\(minute):\(second) EDT \(year)"   // fix the Int key, increment by 1 later when i have time
        cell.textLabel?.text = label
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "purityDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "purityDetailSegue" {
            let nav = segue.destination as! PurityDetailViewController
            nav.reportNum = Self.purityReports[selectedIndex].keys.first!
            let report = Self.purityReports[selectedIndex][selectedIndex + 1]
            nav.reporter = String(describing: (report?["reporter"])!)
            nav.latitude = report?["latitude"]! as! Double!
            nav.longitude = report?["longitude"]! as! Double!
            nav.virus = report?["virusPPM"]! as! Double!
            nav.contamination = report?["contaminantPPM"]! as! Double!
            nav.condition = String(describing: (report?["overallCondition"])!)
        }
    }
    
    func getWeekDay(num: Int) -> String {
        switch num {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        default:
            return "Sat"
        }
    }
    
    func getMonth(num: Int) -> String {
        switch num {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        default:
            return "Dec"
        }
    }



}
