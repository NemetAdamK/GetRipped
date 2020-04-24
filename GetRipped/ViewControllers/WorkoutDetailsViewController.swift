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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCircularButtonLayout(button: detalisScreenBackButton, view: view)
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
