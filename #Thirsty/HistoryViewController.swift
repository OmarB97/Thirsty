//
//  HistoryViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/22/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit
import DropDown
import Charts
import FirebaseDatabase

class HistoryViewController: UIViewController, UITextFieldDelegate {
    
    private typealias `Self` = HistoryViewController
    static var purityReports: [[Int: Dictionary<String, Any>]] = []
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var monthsCount: [String: Double] = ["Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0]
    var ppmList: [String: Double] = ["Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0]

    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var typeView: UIView!
    let typeDropDown = DropDown()
    var type: String?
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var keyBoardHeightLayoutConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        latitudeField.delegate = self
        longitudeField.delegate = self
        yearField.delegate = self
        latitudeField.tag = 0
        longitudeField.tag = 1
        yearField.tag = 2
        self.title = "Submit Purity Report"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func selectType(_ sender: Any) {
        self.view.endEditing(true)
        typeDropDown.anchorView = typeView
        typeDropDown.dataSource = ["Virus", "Contaminant"]
        typeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.type = item
            self.typeLabel.text = "Type: \(item)"
            
        }
        typeDropDown.show()
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
    
    
    @IBAction func viewGraph(_ sender: Any) {
        
        if latitudeField.text?.characters.count == 0 || longitudeField.text?.characters.count == 0 || yearField.text?.characters.count == 0 || type == nil {
            displayError(for: nil, error: "One or more fields are empty.")
            return
        }
        guard let latNum = Double(latitudeField.text!.trimmingCharacters(in: .whitespaces)), let lonNum = Double(longitudeField.text!.trimmingCharacters(in: .whitespaces)), let yearNum = Int(yearField.text!) else {
            displayError(for: latitudeField, error: "Invalid latitude and longitude coordinates, or year is incorrect.")
            return
        }
        if latNum < -90 || latNum > 90 || lonNum < -180 || lonNum > 180 {
            displayError(for: nil, error: "Please enter a valid latitude and longitude range.")
            return
        }
        
        for (index, rep) in (Self.purityReports).enumerated() {
            let report = rep[index + 1]
            let latitude = report?["latitude"]! as! Double!
            let longitude = report?["longitude"]! as! Double!
            let reportDate = Self.purityReports[index][index + 1]! as Dictionary<String, AnyObject>
            let date = reportDate["date"]!, monthNum = date["months"]!!
            let month = getMonth(num: monthNum as! Int)
            let year = date["year"]!! as! Int
            
            if latitude! == latNum && longitude! == lonNum && year == yearNum {
                //print("we got longitude \(String(describing: longitude!)) !!!!!!!!!")
                //let type1 = String(describing: (report?["type"])!)
                let ppm = report?["\(type!.lowercased())PPM"]! as! Double!
                ppmList[month] = ppmList[month]! + ppm!
                monthsCount[month] = monthsCount[month]! + 1.0
            }
        }
        var vals: [Double] = []
        for month in months {
//            print(ppmList[month]!)
//            print(monthsCount[month]!)
            if monthsCount[month]! != 0 {
                vals.append(ppmList[month]! / monthsCount[month]!)
            } else {
                vals.append(ppmList[month]!)
            }
        }
        
        //print(vals)
        
        var yValues : [ChartDataEntry] = [ChartDataEntry]()
        //lineChartView.xAxis.enabled = false
        let data = LineChartData()
        for i in 0 ..< months.count {
             yValues.append(ChartDataEntry(x: Double(i + 1), y: vals[i]))
        }
        let ds = LineChartDataSet(values: yValues, label: "PPM")
        data.addDataSet(ds)
        
        //lineChartView.xAxis.granularity = 1
        let chartFormatter = LinechartFormatter(labels: months)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.lineChartView.xAxis.valueFormatter = xAxis.valueFormatter
        self.lineChartView.xAxis.labelPosition = .bottom
        lineChartView.chartDescription?.text = ""
        self.lineChartView.data = data
//        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        lineChartView.animate(xAxisDuration: 6)

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

private class LinechartFormatter: NSObject, IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //print(Int(value))
        return labels[Int(value) - 1]
    }
    
    init(labels: [String]) {
        super.init()
        self.labels = labels
    }
}
