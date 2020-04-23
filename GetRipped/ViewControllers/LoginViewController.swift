//
//  ViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmailTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var errorLoginLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLoginLabel.alpha = 0
    }
    
    func showError(message: String){
        errorLoginLabel.text = message
        errorLoginLabel.alpha=1
    }

    @IBAction func loginTapped(_ sender: Any) {
        let email = loginEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = loginPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == "" || password == ""{
            showError(message: "Please fill in all fields")

        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showError(message: "Could not sign in")
                } else{
                    let homeScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC")
                    self.view.window?.rootViewController = homeScreenViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
        
        
    }
    
}

