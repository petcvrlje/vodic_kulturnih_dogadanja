//
//  UnregisteredEventTableViewCell.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 02/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

///Cell view for showing event (unregistered user)
class UnregisteredEventTableViewCell: UITableViewCell {

    @IBOutlet weak var unregisteredImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var beginLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
