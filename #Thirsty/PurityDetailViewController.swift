//
//  PurityDetailViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/24/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class PurityDetailViewController: UIViewController {

    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var virusLabel: UILabel!
    @IBOutlet weak var contaminationLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    var reportNum: Int!
    var reporter: String!
    var latitude: Double!
    var longitude: Double!
    var virus: Double!
    var contamination: Double!
    var condition: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportLabel.text = "Report #\(reportNum!) created by \(reporter!)"
        latitudeLabel.text = "Latitude: \(String(format: "%.1f", latitude!))"
        longitudeLabel.text = "Longitude: \(String(format: "%.1f", longitude!))"
        virusLabel.text = "Virus PPM: \(String(format: "%.1f", virus!))"
        contaminationLabel.text = "Contamination PPM: \(String(format: "%.1f", contamination!))"
        conditionLabel.text = "Condition: \(condition!)"
    }

}
