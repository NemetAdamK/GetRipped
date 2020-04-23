//
//  ViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit

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

    @IBAction func loginTapped(_ sender: Any) {
        
    }
    
}

