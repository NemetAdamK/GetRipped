//
//  NewWorkoutViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 23/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit

class NewWorkoutViewController: UIViewController {

    @IBOutlet weak var workoutNameTextField: UITextField!
    
    @IBOutlet weak var burnedCaloriesTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var workoutDurationTextField: UITextField!
    
    @IBOutlet weak var backButtonOnNewWorkout: UIButton!
    
    @IBOutlet weak var addWorkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCircularButtonLayout(button: backButtonOnNewWorkout, view: view)
        setButtonLayout(button: addWorkoutButton)
        setTextFieldLayout(textField: workoutNameTextField)
        setTextFieldLayout(textField: burnedCaloriesTextField)
        setTextFieldLayout(textField: workoutDurationTextField)
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
