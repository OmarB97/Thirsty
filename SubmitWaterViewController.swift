//
//  SubmitWaterViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/19/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit
import DropDown

class SubmitWaterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var wasteView: UIView!
    var water: String?
    var waste: String?
    let waterDropDown = DropDown()
    let wasteDropDown = DropDown()
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var wasteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        latitudeField.delegate = self
        longitudeField.delegate = self
        latitudeField.tag = 0
        longitudeField.tag = 1
        self.title = "Submit Water Report"

    }
    
    @IBAction func waterTypeButton(_ sender: Any) {
        self.view.endEditing(true)
        waterDropDown.anchorView = waterView
        waterDropDown.dataSource = ["Bottled", "Well", "Stream", "Lake", "Spring", "Other"]
        waterDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.water = item
            self.waterLabel.text = "Current Water Type: \(item)"

        }
        waterDropDown.show()
    }

    @IBAction func wasteConditionButton(_ sender: Any) {
        self.view.endEditing(true)
        wasteDropDown.anchorView = wasteView
        wasteDropDown.dataSource = ["Waste", "Treatable-Clear", "Treatable-Muddy", "Portable"]
        //wasteDropDown.direction = .any
        wasteDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.waste = item
            self.wasteLabel.text = "Current Waste Condition: \(item)"
        }
        wasteDropDown.show()
    }
    
    @IBAction func submitReport(_ sender: Any) {
        if latitudeField.text?.characters.count == 0 || longitudeField.text?.characters.count == 0 || water == nil || waste == nil {
            displayError(for: nil, error: "One or more fields are empty.")
            return
        }
        guard let latNum = Double(latitudeField.text!), let lonNum = Double(longitudeField.text!) else {
                displayError(for: latitudeField, error: "Invalid latitude and longitude coordinates.")
                return
            }
        // add to database
        // return back to home page
        
        var keyNum = 0
        WelcomeViewController.sourceDB.observe(.value, with: { (snapshot) in
            keyNum = Int(snapshot.childrenCount)
        })
        LoginViewController.delay(bySeconds: 0.2) {
            let waterReport = WelcomeViewController.sourceDB.child(String(keyNum))
            let swiftDate = Date()
            let calendar = Calendar.current
            let date = calendar.component(.day, from: swiftDate)
            let weekday = calendar.component(.weekday, from: swiftDate)
            let hours = calendar.component(.hour, from: swiftDate)
            let minutes = calendar.component(.minute, from: swiftDate)
            let months = calendar.component(.month, from: swiftDate)
            let seconds = calendar.component(.second, from: swiftDate)
            let year = calendar.component(.year, from: swiftDate)
            
            let dateInfo = ["date": date, "weekday": weekday, "hours": hours, "minutes": minutes, "months": months, "seconds": seconds, "year": year]
            let reportInfo = ["latitude":  latNum, "longitude": lonNum, "reportNum": keyNum, "reporter": WelcomeViewController.userProfile.username!, "waterCondition": self.water!, "wasteCondition": self.waste!] as [String : Any]
            waterReport.setValue(reportInfo)
            
            let dateChild = waterReport.child("date")
            dateChild.setValue(dateInfo)
            
            self.performSegue(withIdentifier: "unwindToHome", sender: sender)
        }
    }
    
    func displayError(for view: UIView?, error issue: String) {
        let ac = UIAlertController(title: "Error Registering", message: "\(issue)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> () in
            if let realView = view {
                if realView == self.latitudeField {
                    self.latitudeField.text?.removeAll()
                    self.longitudeField.text?.removeAll()
                }
                realView.becomeFirstResponder()
            }
        }))
        present(ac, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToHome" {
            let nav = segue.destination as! HomeViewController
            nav.didSubmitWater = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true;
        }
        return false
    }
    
}
