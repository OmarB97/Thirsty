//
//  ProfileViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 4/16/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var didUpdateEmail = false
    var didUpdatePass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if didUpdateEmail {
            let ac = UIAlertController(title: "Success", message: "Successfully Updated Email", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            didUpdateEmail = false
        } else if didUpdatePass {
            let ac = UIAlertController(title: "Success", message: "Successfully Updated Password", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            didUpdatePass = false
        }
    }
    
    @IBAction func updateEmail(_ sender: Any) {
        performSegue(withIdentifier: "updateEmailSegue", sender: sender)
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        performSegue(withIdentifier: "updatePassSegue", sender: sender)
    }
    
    
    @IBAction func goHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindHomeSegue", sender: sender)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        performSegue(withIdentifier: "unwindToWelcomeSegue", sender: sender)
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToWelcomeSegue" {
            let nav = segue.destination as! WelcomeViewController
            nav.didLogout = true
            WelcomeViewController.userProfile = UserProfile()
            
        }
    }
    

}
