//
//  EmailViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/21/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateEmailButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update Email"
        self.hideKeyboardWhenTappedAround()
        emailTextField.tag = 0
        emailTextField.delegate = self

    }

   
    
    @IBAction func updateEmail(_ sender: Any) {
        
        if emailTextField.text?.characters.count == 0 {
            displayError(for: emailTextField, error: "Text field is empty.")
        } else if !isValidEmail(testStr: emailTextField.text!) {
            displayError(for: emailTextField, error: "Email provided is invalid.")
        } else {
            performSegue(withIdentifier: "unwindToProfile", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("hello")
        if segue.identifier == "unwindToProfile" {
            let currentUser = WelcomeViewController.userDB.child((WelcomeViewController.userProfile.username)!)
            currentUser.updateChildValues(["Email": emailTextField.text!])
            let nav = segue.destination as! ProfileViewController
            nav.didUpdateEmail = true
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func displayError(for field: UITextField?, error issue: String) {
        let ac = UIAlertController(title: "Error Registering", message: "\(issue)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> () in
            field?.becomeFirstResponder()
        }))
        present(ac, animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            updateEmailButton.sendActions(for: UIControlEvents.touchUpInside)
            return true;
        }
        return false
    }
}
