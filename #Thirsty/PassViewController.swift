//
//  PassViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/21/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class PassViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var updatePassButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update Password"
        self.hideKeyboardWhenTappedAround()
        
        passTextField.tag = 0
        confirmPassTextField.tag = 1
        passTextField.delegate = self
        confirmPassTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func updatePassword(_ sender: Any) {
        self.view.endEditing(true)
        // check if all things are filled out, then check to see if all are valid
        if passTextField.text?.characters.count == 0 || confirmPassTextField.text?.characters.count == 0 {
            displayError(for: nil, error: "One or more text fields are empty.")
        } else if passTextField.text != confirmPassTextField.text {
            displayError(for: confirmPassTextField, error: "Password fields do not match.")
        } else {
            performSegue(withIdentifier: "unwindToProfile", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let currentUser = WelcomeViewController.userDB.child((WelcomeViewController.userProfile.username)!)
        currentUser.updateChildValues(["Password": passTextField.text!])
        if segue.identifier == "unwindToProfile" {
            let nav = segue.destination as! ProfileViewController
            nav.didUpdatePass = true
        }
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
            updatePassButton.sendActions(for: UIControlEvents.touchUpInside)
            return true;
        }
        return false
    }
    
    
}
