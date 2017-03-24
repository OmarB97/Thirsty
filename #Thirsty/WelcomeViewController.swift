//
//  ViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 3/14/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var didRegisterSuccessfully = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 157/255, green: 191/255, blue: 1.00, alpha: 1.00)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if didRegisterSuccessfully {
            let ac = UIAlertController(title: title, message: "Successfully Registered!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            didRegisterSuccessfully = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navController.navigationBar.backItem?.setHidesBackButton(true, animated: true)
        self.navigationController!.navigationBar.backItem?.setHidesBackButton(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navController.navigationBar.backItem?.setHidesBackButton(true, animated: true)
        self.navigationController!.navigationBar.backItem?.setHidesBackButton(false, animated: true)
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func loginSelected(_ sender: Any) {
        performSegue(withIdentifier: "loginSelectSegue", sender: sender)
    }


    @IBAction func registerSelected(_ sender: Any) {
        performSegue(withIdentifier: "registerSelectSegue", sender: sender)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "loginSelectSegue" {
////            let nav = segue.destination as! LoginViewController
////        } else {
////            let nav = segue.destination as! RegisterViewController
////        }
//    }
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) {
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

