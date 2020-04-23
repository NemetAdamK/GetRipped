//
//  SignUpViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var reEnteredPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0

    }
    

    @IBAction func signUpTapped(_ sender: Any) {
    }
    
}
