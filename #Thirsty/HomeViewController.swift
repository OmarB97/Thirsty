//
//  HomeViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 3/14/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit
import FirebaseDatabase


class HomeViewController: UIViewController {
    
    var fromLogin = false
    var didSubmitWater = false


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        if fromLogin {
            navigationController?.viewControllers.remove(at: 1)
            fromLogin = false
        } else if didSubmitWater {
            let ac = UIAlertController(title: "Success", message: "Successfully Submitted Water Report", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            didSubmitWater = false
        }
        
    }
    
    @IBAction func viewProfile(_ sender: Any) {
        performSegue(withIdentifier: "profileSegue", sender: sender)
    }

    @IBAction func viewPurityReports(_ sender: Any) {
    }
    
    @IBAction func submitReport(_ sender: Any) {
        performSegue(withIdentifier: "submitReportSegue", sender: sender)
    }
    
    @IBAction func submitPurityReport(_ sender: Any) {
    }
    
    @IBAction func viewMap(_ sender: Any) {
    }
    
    @IBAction func viewReports(_ sender: Any) {
        WelcomeViewController.sourceDB.observe(.value, with: { (snapshot) in
            var listOfReports: [[Int: Dictionary<String, Any>]] = []
            for childSnap in snapshot.children.allObjects {
                let snap = childSnap as! FIRDataSnapshot
                let reportNum = Int(snap.key)!
                let value = snap.value as! NSDictionary
                let date = value["date"] as! NSDictionary
                var valueDict = value as! Dictionary<String, Any>
                let dateDict = date as! Dictionary<String, Any>
                valueDict["date"] = dateDict
                let report: [Int: Dictionary<String, Any>] = [reportNum: valueDict]
                listOfReports.append(report)
            }
            ReportListViewController.waterReports = listOfReports
        })
        LoginViewController.delay(bySeconds: 0.2) {
            self.performSegue(withIdentifier: "viewReportListSegue", sender: sender)
        }
    }
    
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    
}

//public extension UINavigationController {
//    
//    func pushViewControllerFromTop(viewController vc: UIViewController) {
//        vc.view.alpha = 0
//        self.present(vc, animated: false) { () -> Void in
//            // CGRectMake(0, -vc.view.frame.height, vc.view.frame.width, vc.view.frame.height)
//            vc.view.frame = CGRect(x: 0, y: -vc.view.frame.height, width: vc.view.frame.width, height: vc.view.frame.height)
//            vc.view.alpha = 1
//            UIView.animate(withDuration: 1, animations: { () -> Void in
//                // CGRectMake(0, 0, vc.view.frame.width, vc.view.frame.height)
//                vc.view.frame = CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height)
//            },
//                                       completion: nil)
//        }
//    }
//    
//    func dismissViewControllerToTop() {
//        if let vc = self.presentedViewController {
//            UIView.animate(withDuration: 1, animations: { () -> Void in
//                // CGRectMake(0, -vc.view.frame.height, vc.view.frame.width, vc.view.frame.height)
//                vc.view.frame = CGRect(x: 0, y: -vc.view.frame.height, width: vc.view.frame.width, height: vc.view.frame.height)
//            }, completion: { (complete) -> Void in
//                if complete == true {
//                    self.dismiss(animated: false, completion: nil)
//                }
//            })
//        }
//    }
//}
