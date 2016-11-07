//
//  SegmentedControlTableViewCell.swift
//  SpotifySearch
//
//  Created by Cris on 11/5/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit


protocol SegmentedControlDelegate {
    func didSelectMusicType(ofType: albumType)
}


class SegmentedControlTableViewCell: UITableViewCell {
    internal var delegate: SegmentedControlDelegate?

    @IBOutlet weak var MusicType: UISegmentedControl!
    
    func indexToMusictype(index: Int) -> albumType {
        switch index {
        case 0: return .album
        case 1: return .artist
        case 2: return .track
        default: return .playlist
        }
    }
    
    
    @IBAction func didSelectType(_ sender: UISegmentedControl) {
        self.delegate?.didSelectMusicType(ofType: indexToMusictype(index: sender.selectedSegmentIndex))
    }
    
    
    func typeToValues(ofType: albumType) -> Int {
        switch ofType {
        case .album: return 0
        case .artist: return 1
        case .track: return 2
        case .playlist: return 3
        }
    }
    
    func setMusicTypes(to: albumType) {
        MusicType.selectedSegmentIndex = typeToValues(ofType: to)
    }
    
    

}
