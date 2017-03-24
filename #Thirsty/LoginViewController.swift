//
//  LoginViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 3/14/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginSuccessful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Login"
    }

    @IBAction func loginRequested(_ sender: Any) {
        if loginSuccessful {
            loginSuccessful = false
            performSegue(withIdentifier: "homePageSegue", sender: sender)
        } else {
            let ac = UIAlertController(title: title, message: "Login failed. Please try again or register.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: tryAgain))
            ac.addAction(UIAlertAction(title: "Register", style: .default, handler: goToRegisterScreen))
            present(ac, animated: true)
            loginSuccessful = true      // temporary
        }
    }
    
    func tryAgain(action: UIAlertAction! = nil) {
        usernameTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
        usernameTextField.becomeFirstResponder()
        
    }
    
    func goToRegisterScreen(action: UIAlertAction! = nil) {
        performSegue(withIdentifier: "loginToRegisterSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToRegisterSegue" {
            let nav = segue.destination as! RegisterViewController
            nav.cameFromLogin = true
            self.navigationItem.title = ""
        }
    }
    
    
}
