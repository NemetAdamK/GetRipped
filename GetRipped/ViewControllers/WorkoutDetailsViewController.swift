//
//  WorkoutDetailsViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 23/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WorkoutDetailsViewController: UIViewController {

    
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var burnedCaloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var workoutImage: UIImageView!
    
    @IBOutlet weak var detalisScreenBackButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCircularButtonLayout(button: detalisScreenBackButton, view: view)
        setCircularButtonLayout(button: signOutButton,view: view)
        
        setCircularButtonLayout(button: profileButton,view: view)
        
        
        print("Workout index2" , indexOfWorkout)
        var indexSearch = 0
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        ref.observe(.value, with: { (snapshot) in
            
            
            for workouts in snapshot.children.allObjects as! [DataSnapshot] {
                print(indexSearch, indexOfWorkout)
                if indexSearch==indexOfWorkout {
                    if let workoutObject = workouts.value as? [String: AnyObject]{
                        let workoutName = workoutObject["workoutName"]
                        let workoutDate = workoutObject["pickedDate"]
                        let workoutTime = workoutObject["workoutDuration"]
                        let photo = workoutObject["photoLink"]
                        let calories = workoutObject["burnedCalories"]
                        
                        self.workoutNameLabel.text = workoutName as? String
                        self.burnedCaloriesLabel.text = calories as? String
                        self.dateLabel.text = workoutDate as? String
                        self.durationLabel.text = workoutTime as? String
                        
                        if let url = URL(string:  photo as? String ?? ""){
                            do {
                                let data = try Data(contentsOf: url)
                                self.workoutImage.image = UIImage(data: data)
                            } catch let err{
                                print(err.localizedDescription)
                            }
                        }
                        
                    }
                    
                }
                indexSearch = indexSearch + 1
            }
            
        })
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
     
        
        
        
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        var ref: DatabaseReference!
        var name = ""
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userDict = snapshot.value as! [String: Any]
            
            name = userDict["username"] as! String
            
            self.changeUserNameAlert(string: name)
            
    })
    }
        
        func changeUserNameAlert(string: String){
            let alert = UIAlertController(title: "Do you want to change your username ?", message: "Your current username: \(string)",  preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let newName = textField?.text
                if newName != ""{
                    self.setNewUserName(newUserName: newName!)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        func setNewUserName(newUserName: String){
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            ref.child("users").child(Auth.auth().currentUser!.uid).child("user").setValue(["username":newUserName])
        }
        
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure ?", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "uid")
            defaults.synchronize()
            let homeScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: "initController")
            self.view.window?.rootViewController = homeScreenViewController
            self.view.window?.makeKeyAndVisible()
            
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "No", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
