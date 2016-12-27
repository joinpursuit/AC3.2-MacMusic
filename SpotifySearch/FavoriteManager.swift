//
//  FavoriteManager.swift
//  SpotifySearch
//
//  Created by Ana Ma on 12/27/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation
import UIKit

class FavoriteManager {
    
    var track: AlbumTracks
    var isAlreadyAdded: Bool
    
    init(track: AlbumTracks, isAlreadyAdded: Bool) {
        self.track = track
        self.isAlreadyAdded = isAlreadyAdded
    }
    
    func addToFavorites() {
        let userDefaults = UserDefaults.standard
        
        var favoriteSong = [String: String]()
        favoriteSong.updateValue(track.trackID, forKey: "track_id")
        favoriteSong.updateValue(track.trackName, forKey: "track_name")
        favoriteSong.updateValue(track.singerName, forKey: "artist_name")
        favoriteSong.updateValue(String(track.trackLyrics), forKey: "track_lyrics_id")
        favoriteSong.updateValue(String(track.trackNumber), forKey: "track_number")
        favoriteSong.updateValue(track.trackPreviewURL, forKey: "track_preview_URL")
        favoriteSong.updateValue(track.albumImg, forKey: "album_Img")
        
        if var favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
            favoriteSongs.append(favoriteSong)
            userDefaults.set(favoriteSongs, forKey: "favoriteSongs")
        } else {
            userDefaults.set([favoriteSong], forKey: "favoriteSongs")
        }
        isAlreadyAdded = true
    }
    
    func removeFromFavorites() {
        let userDefaults = UserDefaults.standard
        
        if var favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
            for (index,song) in favoriteSongs.enumerated() {
                if song["track_id"] == track.trackID {
                    favoriteSongs.remove(at: index)
                    userDefaults.set(favoriteSongs, forKey: "favoriteSongs")
                    isAlreadyAdded = false
                }
            }
        }
    }
    
    func favoriteSongPressed(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        
        if let favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
            for song in favoriteSongs {
                if song["track_id"] == track.trackID {
                    isAlreadyAdded = true
                }
            }
        }
        
        if isAlreadyAdded == false {
            addToFavorites()
            sender.setBackgroundImage(UIImage(named: "minus-5-512"), for: UIControlState.normal)
        } else {
            removeFromFavorites()
            sender.setBackgroundImage(UIImage(named: "plus-circle-outline"), for: UIControlState.normal)
        }
    }
    
    func updateButtonStatus(_ button: UIButton) {
        let userDefaults = UserDefaults.standard
        if let favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
            for song in favoriteSongs {
                if song["track_id"] == self.track.trackID {
                    self.isAlreadyAdded = true
                }
            }
        }
        
        if isAlreadyAdded == false {
            button.setBackgroundImage(UIImage(named: "plus-circle-outline"), for: UIControlState.normal)
        } else {
            button.setBackgroundImage(UIImage(named: "minus-5-512"), for: UIControlState.normal)
        }
    }
}
