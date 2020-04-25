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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCircularButtonLayout(button: detalisScreenBackButton, view: view)
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
