//
//  WorkoutModel.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 24/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

class WorkoutModel{
    var workoutName: String?
    var workoutDuration: String?
    var pickedDate: String?
    var photoLink: String?
    var burnedCalories: String?

    init(workoutName: String?,
    workoutDuration: String?,
    pickedDate: String?,
    photoLink: String?,
    burnedCalories: String?){
        
        self.workoutName = workoutName
        self.workoutDuration = workoutDuration
        self.pickedDate = pickedDate
        self.photoLink = photoLink
        self.burnedCalories = burnedCalories
        
    }
}
