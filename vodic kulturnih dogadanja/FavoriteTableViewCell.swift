//
//  FavoriteTableViewCell.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 06/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteName: UILabel!
    @IBOutlet weak var favoriteDescription: UILabel!
    @IBOutlet weak var favoriteBegin: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
