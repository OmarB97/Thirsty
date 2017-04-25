//
//  ReportDetailViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/22/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class ReportDetailViewController: UIViewController {
    
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var waterTypeLabel: UILabel!
    @IBOutlet weak var waterConditionLabel: UILabel!
    
    var reportNum: Int!
    var reporter: String!
    var latitude: Double!
    var longitude: Double!
    var waterType: String!
    var waterCondition: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        reportLabel.text = "Report #\(reportNum!) created by \(reporter!)"
        latitudeLabel.text = "Latitude: \(String(format: "%.1f", latitude!))"
        longitudeLabel.text = "Longitude: \(String(format: "%.1f", longitude!))"
        waterTypeLabel.text = "Water Type: \(waterType!)"
        waterConditionLabel.text = "Water Condition: \(waterCondition!)"
    }
    
}
