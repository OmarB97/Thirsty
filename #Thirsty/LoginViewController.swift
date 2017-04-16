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
    
    private var loginSuccessful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Login"
    }

    @IBAction func loginRequested(_ sender: Any) {
        
        // need to query database
        
        loading()
        delay(bySeconds: 1.5) {
            if self.loginSuccessful {
                self.loginSuccessful = false // might move to logout method
                self.updateUserProfile()
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
        checkUserPass()
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkUserPass() {
        WelcomeViewController.userDB.child(usernameTextField.text!).observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot.exists())
//            print((snapshot.childSnapshot(forPath: "Password").value as! String))
            if snapshot.exists() && (snapshot.childSnapshot(forPath: "Password").value as! String) == self.passwordTextField.text! {
                self.loginSuccessful = true
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
    
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    public enum DispatchLevel {
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
    
    
}
