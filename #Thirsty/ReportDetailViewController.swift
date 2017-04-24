//
//  ReportDetailViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/22/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class ReportDetailViewController: UIViewController {
    
    var reportNum: Int!
    var reporter: String!
    var latitude: Double!
    var longitude: Double!
    var waterType: String!
    var waterCondition: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(reportNum, reporter, latitude, longitude, waterType, waterCondition)

        // Do any additional setup after loading the view.
    }
    
}
