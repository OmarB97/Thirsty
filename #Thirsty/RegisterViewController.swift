//
//  RegisterViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 3/14/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var cameFromLogin = false
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Register"

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cameFromLogin {
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
    
    @IBAction func registerRequested(_ sender: Any) {
        performSegue(withIdentifier: "unwindToWelcomeSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToWelcomeSegue" {
            let nav = segue.destination as! WelcomeViewController
            nav.didRegisterSuccessfully = true
        }
    }

}
