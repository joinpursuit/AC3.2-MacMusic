//
//  File.swift
//  SpotifySearch
//
//  Created by Marcel Chaucer on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

class Artist {
    
    let artistID: String
    let image: String
    let artistName: String
    
    init(artistID: String, image: String, artistName: String) {
        self.artistID = artistID
        self.image = image
        self.artistName = artistName
    }
    
    static func getArtists(from data: Data) -> [Artist]? {
        var artistInfo = [Artist]()
        do {
            let artistJSONData: Any = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let artistsCasted = artistJSONData as? [String : Any],
            let artistArr = artistsCasted["artists"] as? [[String : Any]] else {return nil}
            
            for artists in artistArr {
              guard let artistID = artists["id"] as? String,
                let imageArray = artists["images"] as? [[String: Any]],
                let image = imageArray[1]["url"] as? String,
                let artistName = artists["name"] as? String else {return nil}
               
                let fullArtistInfo = Artist(artistID: artistID, image: image, artistName: artistName)
                artistInfo.append(fullArtistInfo)
            }
}
        return artistInfo
}
}
