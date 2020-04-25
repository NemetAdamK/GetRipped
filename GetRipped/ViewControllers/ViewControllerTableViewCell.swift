//
//  ViewControllerTableViewCell.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 24/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutNameLabel: UILabel!
    
    
    @IBOutlet weak var workoutDateLabel: UILabel!
    
    @IBOutlet weak var workoutImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
