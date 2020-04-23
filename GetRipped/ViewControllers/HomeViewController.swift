//
//  HomeViewController.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeScreenAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCircularButtonLayout(button: homeScreenAddButton,view: view)
    }
    

}
