//
//  HomeViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableWorkouts: UITableView!
    
    @IBOutlet weak var homeScreenAddButton: UIButton!
    
    var workoutList = [WorkoutModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableWorkouts.rowHeight = 120;
        
        tableWorkouts.layer.masksToBounds = true
        tableWorkouts.layer.borderWidth = 1
        let borderColor: UIColor = .black
        tableWorkouts.layer.borderColor = borderColor.cgColor
        tableWorkouts.bounces = false
        setCircularButtonLayout(button: homeScreenAddButton,view: view)
        
        let ref = Database.database().reference().child("users").child(personalID)
        
        ref.observe(.value, with: { (snapshot) in
    
            for workouts in snapshot.children.allObjects as! [DataSnapshot] {
                
               
                if let workoutObject = workouts.value as? [String: AnyObject]{
                let workoutName = workoutObject["workoutName"]
                let workoutDate = workoutObject["pickedDate"]
                let workoutTime = workoutObject["workoutDuration"]
                let photo = workoutObject["photoLink"]
                let calories = workoutObject["burnedCalories"]
                let createdDate = workoutObject["createdDate"]
                
                let workout = WorkoutModel(workoutName: workoutName as! String?,
                                               workoutDuration: workoutTime as! String?,
                                               pickedDate: workoutDate as! String?,
                                               photoLink: photo as! String?,
                                               burnedCalories: calories as! String?,
                                               createdDate: createdDate as! String?)
                workoutDetailList.append(workout)
                self.workoutList.append(workout)
                }
            }
            self.tableWorkouts.reloadData()
        })
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.count
    }
    
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexOfWorkout = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let workout: WorkoutModel
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        let borderColor: UIColor = .black
        cell.layer.borderColor = borderColor.cgColor
        
        workout = workoutList[indexPath.row]
        
        cell.workoutNameLabel.text = workout.workoutName
        cell.workoutDateLabel.text = workout.pickedDate
        if let url = URL(string: workout.photoLink ?? ""){
            do {
                let data = try Data(contentsOf: url)
                cell.workoutImage.image = UIImage(data: data)
            } catch let err{
                print(err.localizedDescription)
            }
        }
        return cell
    }
    
    

}
