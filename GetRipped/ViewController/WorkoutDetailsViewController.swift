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
import Firebase
import FirebaseStorage
import FirebaseFirestore

class WorkoutDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var burnedCaloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var workoutImage: UIImageView!
    
    @IBOutlet weak var detalisScreenBackButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setDetailScreenLayout()
        setDetailScreenData()
        
        
    }
    
    // Refreshing profile picture on each time view appears
    

    
    
    func setDetailScreenLayout(){
        setCircularButtonLayout(button: detalisScreenBackButton, view: view)
    }
    
    func setDetailScreenData(){
        var indexSearch = 0
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        ref.observe(.value, with: { (snapshot) in
            
            
            for workouts in snapshot.children.allObjects as! [DataSnapshot] {
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
    
}

