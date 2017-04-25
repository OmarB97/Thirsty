//
//  LoginViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 3/14/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var loginSuccessful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Login"
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.tag = 0
        passwordTextField.tag = 1
    }

    @IBAction func loginRequested(_ sender: Any) {
        
        // need to query database
        //self.view.endEditing(true)
        checkUserPass()
        loading()
        LoginViewController.delay(bySeconds: 1.5) {
            if self.loginSuccessful {
                self.loginSuccessful = false // might move to logout method
                self.performSegue(withIdentifier: "homePageSegue", sender: sender)
            } else {
                let ac = UIAlertController(title: self.title, message: "Login failed. Please try again or register.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: self.tryAgain))
                ac.addAction(UIAlertAction(title: "Register", style: .default, handler: self.goToRegisterScreen))
                self.present(ac, animated: true)
            }
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
        } else if segue.identifier == "homePageSegue" {
            let nav = segue.destination as! HomeViewController
            nav.fromLogin = true
        }
    }
    
    func loading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkUserPass() {
        WelcomeViewController.userDB.child(usernameTextField.text!).observe(.value, with: { snapshot in
            if snapshot.exists() && (snapshot.childSnapshot(forPath: "Password").value as! String) == self.passwordTextField.text! {
                self.loginSuccessful = true
                self.updateUserProfile()
            }
        })
    }
    
    func updateUserProfile() {
        let userInfo = WelcomeViewController.userDB.child(self.usernameTextField.text!)
        userInfo.observeSingleEvent(of: .value, with: { (snapshot) in
            WelcomeViewController.userProfile.username = snapshot.key
            WelcomeViewController.userProfile.password = snapshot.childSnapshot(forPath: "Password").value as? String
            WelcomeViewController.userProfile.email = snapshot.childSnapshot(forPath: "Email").value as? String
            WelcomeViewController.userProfile.userType = snapshot.childSnapshot(forPath: "User Type").value as? String
//            print(WelcomeViewController.userProfile.username ?? "Username doesn't exist")
//            print(WelcomeViewController.userProfile.password ?? "Password doesn't exist")
//            print(WelcomeViewController.userProfile.email ?? "Email doesn't exist")
//            print(WelcomeViewController.userProfile.userType ?? "User Type doesn't exist")
        })
    }
    
    static func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButton.sendActions(for: UIControlEvents.touchUpInside)
            return true;
        }
        return false
    }
    
}
