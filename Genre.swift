//
//  Genre.swift
//  SpotifySearch
//
//  Created by Ana Ma on 11/8/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

class Genre {
    var music_genre_parent_id: Int
    var music_genre_id: Int
    var music_genre_name: String
    var music_genre_name_extended: String
    var music_genre_vanity: String
    
    init? (music_genre_parent_id : Int, music_genre_id : Int, music_genre_name : String, music_genre_name_extended: String, music_genre_vanity: String) {
        self.music_genre_parent_id = music_genre_parent_id
        self.music_genre_id = music_genre_id
        self.music_genre_name = music_genre_name
        self.music_genre_name_extended = music_genre_name_extended
        self.music_genre_vanity = music_genre_vanity
    }
    
    convenience init? (from musicGenre: [String:Any]?){
        if let music_genre = musicGenre?["music_genre"] as? [String: Any],
            let music_genre_id = music_genre["music_genre_id"] as? Int,
            let music_genre_parent_id = music_genre["mmusic_genre_parent_id"] as? Int,
            let music_genre_name = music_genre["music_genre_name"] as? String,
            let music_genre_name_extended = music_genre["music_genre_name_extended"] as? String,
            let music_genre_vanity = music_genre["music_genre_vanity"] as? String {
            self.init(music_genre_parent_id : music_genre_parent_id, music_genre_id : music_genre_id, music_genre_name : music_genre_name, music_genre_name_extended: music_genre_name_extended, music_genre_vanity: music_genre_vanity)
        } else {
            return nil
        }
    }
}
