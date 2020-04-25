//
//  globals.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 23/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import Foundation
import UIKit

var indexOfWorkout = 0

var loggedUser = false

public func setCircularButtonLayout(button: UIButton,view: UIView){
    button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
    button.layer.cornerRadius = button.frame.height * 0.50
    button.clipsToBounds = true
    button.layer.borderWidth = 1.0
    
    view.addSubview(button)
}

func setTextFieldLayout(textField: UITextField){
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


