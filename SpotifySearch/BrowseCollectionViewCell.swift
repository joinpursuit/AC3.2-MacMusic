//
//  BrowseCollectionViewCell.swift
//  SpotifySearch
//
//  Created by Marcel Chaucer on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class BrowseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    override func prepareForReuse() {
        self.artistImage.image = nil
    }
}
