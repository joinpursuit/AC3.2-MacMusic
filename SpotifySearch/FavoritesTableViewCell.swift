//
//  FavoritesTableViewCell.swift
//  SpotifySearch
//
//  Created by Cris on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var favoritesTrackImageView: UIImageView!
    @IBOutlet weak var favoriteTrackLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.favoritesTrackImageView.image = nil
    }

}
