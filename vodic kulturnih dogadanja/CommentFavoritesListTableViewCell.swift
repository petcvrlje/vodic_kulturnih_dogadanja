//
//  CommentFavoritesListTableViewCell.swift
//  vodic kulturnih dogadanja
//
//  Created by Faculty of Organisation and Informatics on 22/01/2018.
//  Copyright © 2018 foi. All rights reserved.
//



import UIKit

class CommentFavoriteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentUser: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

