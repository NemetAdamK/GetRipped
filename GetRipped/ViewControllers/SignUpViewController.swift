//
//  SignUpViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

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
    
    func isValidEmail(inputEmail: String) -> Bool {
        let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: inputEmail)
    }
    
    public func isValidPassword(inputPassword: String) -> Bool {
        let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: inputPassword)
    }
    
    func validateInputFields() -> String?{
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            reEnteredPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (!isValidEmail(inputEmail: email)){
            return "Email format is incorrect."
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (!isValidPassword(inputPassword: password)){
            return "Password isn't secure enough. (At least 8 characters long,contains special characters and a number"
        }
        
        let secondPassword = reEnteredPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (password != secondPassword){
            return "Passwords do not match"
        }
        
        
        return nil
        
    }
    
    func navigateToHomeScreen(){
    
        let homeScreenViewController = storyboard?.instantiateViewController(withIdentifier: "HomeScreenVC")
        view.window?.rootViewController = homeScreenViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha=1
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateInputFields()
        
        if error != nil {
            
            showError(message: error!)
           
        } else {
            let userEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let userPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (result, err) in
                if err != nil {
                    
                    self.showError(message: "Error creating user")
                    
                } else {
                    
                   let db = Firestore.firestore()
                    
                    let firstName = self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let lastName = self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    db.collection("users").addDocument(data: ["firstname" : firstName,"lastname" : lastName,"uid" : result!.user.uid], completion: { (error) in
                        if error != nil {
                            self.showError(message: "The username and last name couldn't be saved correctly")
                        }
                    })
                    
                    self.navigateToHomeScreen()
                    
                }
            }
        }
        
        
    }
    
}
