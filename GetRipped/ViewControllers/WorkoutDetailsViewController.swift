//
//  WorkoutDetailsViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 23/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit

class WorkoutDetailsViewController: UIViewController {

    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var burnedCaloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var workoutImage: UIImageView!
    
    @IBOutlet weak var detalisScreenBackButton: UIButton!
    
    var workoutDetailsMore: WorkoutModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setCircularButtonLayout(button: detalisScreenBackButton, view: view)
        
        workoutDetailsMore = workoutDetailList[indexOfWorkout]
        workoutNameLabel.text = workoutDetailsMore.workoutName
        burnedCaloriesLabel.text = workoutDetailsMore.burnedCalories
        dateLabel.text = workoutDetailsMore.pickedDate
        durationLabel.text = workoutDetailsMore.workoutDuration
        if let url = URL(string: workoutDetailsMore.photoLink ?? ""){
            do {
                let data = try Data(contentsOf: url)
                self.workoutImage.image = UIImage(data: data)
            } catch let err{
                print(err.localizedDescription)
            }
        }
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
