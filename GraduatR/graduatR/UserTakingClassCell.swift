//
//  UserTakingClassCell.swift
//  graduatR
//
//  Created by Dhriti Chawla on 4/5/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit

class UserTakingClassCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var propic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
