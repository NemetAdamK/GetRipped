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

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var errorLoginLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLoginLabel.alpha = 0
        
        setButtonLayout(button: loginButton)
        setButtonLayout(button: signUpButton)
        setTextViewLayout(textField: loginEmailTextField)
        setTextViewLayout(textField: loginPasswordTextField)
        print("User id from data: " , UserDefaults.standard.object(forKey: "uid") ?? "None")
        
        
        
    }
    
    
    
    
    func setTextViewLayout(textField: UITextField){
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.clipsToBounds = true
    }
    
    
    func setButtonLayout(button: UIButton){
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
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
                
                    UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "uid")
                    UserDefaults.standard.synchronize()
                    let homeScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC")
                    self.view.window?.rootViewController = homeScreenViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
        
        
    }
    
}

extension UserDefaults {
    
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}

