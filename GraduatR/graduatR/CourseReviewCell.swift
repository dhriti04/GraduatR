//
//  CourseReviewCell.swift
//  graduatR
//
//  Created by Harika Lingareddy on 3/22/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit

class CourseReviewCell: UITableViewCell {

    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
