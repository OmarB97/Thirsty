//
//  SubmitPurityViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/24/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit
import DropDown

class SubmitPurityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var virusField: UITextField!
    @IBOutlet weak var contaminantField: UITextField!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionView: UIView!
    let conditionDropdown = DropDown()
    var condition: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        latitudeField.delegate = self
        longitudeField.delegate = self
        virusField.delegate = self
        contaminantField.delegate = self
        latitudeField.tag = 0
        longitudeField.tag = 1
        virusField.tag = 2
        contaminantField.tag = 3
        self.title = "Submit Purity Report"

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func selectCondition(_ sender: Any) {
        self.view.endEditing(true)
        conditionDropdown.anchorView = conditionView
        conditionDropdown.dataSource = ["Safe", "Treatable", "Unsafe"]
        conditionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.condition = item
            self.conditionLabel.text = "Condition: \(item)"
            
        }
        conditionDropdown.show()
    }
    
    @IBAction func submitReport(_ sender: Any) {
        if latitudeField.text?.characters.count == 0 || longitudeField.text?.characters.count == 0 || virusField.text?.characters.count == 0 || contaminantField.text?.characters.count == 0 || condition == nil {
            displayError(for: nil, error: "One or more fields are empty.")
            return
        }
        guard let latNum = Double(latitudeField.text!), let lonNum = Double(longitudeField.text!), let virusNum = Double(virusField.text!), let contaminantNum = Double(contaminantField.text!) else {
            displayError(for: latitudeField, error: "Invalid latitude and longitude coordinates.")
            return
        }
        if latNum < -90 || latNum > 90 || lonNum < -180 || lonNum > 180 {
            displayError(for: nil, error: "Please enter a valid latitude and longitude range.")
            return
        }
        
        // add to database
        // return back to home page
        
        var keyNum = 0
        WelcomeViewController.sourceDB.observe(.value, with: { (snapshot) in
            keyNum = Int(snapshot.childrenCount) + 1
        })
        LoginViewController.delay(bySeconds: 0.5) {
            let purityReport = WelcomeViewController.purityDB.child(String(keyNum))
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
            let reportInfo = ["latitude":  latNum, "longitude": lonNum, "reportNumber": keyNum, "reporter": WelcomeViewController.userProfile.username!, "overallCondition": self.condition!, "virusPPM": virusNum, "contaminantPPM": contaminantNum] as [String : Any]
            purityReport.setValue(reportInfo)
            
            let dateChild = purityReport.child("date")
            dateChild.setValue(dateInfo)
            
            self.performSegue(withIdentifier: "unwindToHome", sender: sender)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToHome" {
            let nav = segue.destination as! HomeViewController
            nav.didSubmitPurity = true
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
