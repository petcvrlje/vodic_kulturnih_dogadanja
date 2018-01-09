//
//  CommentListTableViewCell.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 17/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class CommentListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentUser: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
