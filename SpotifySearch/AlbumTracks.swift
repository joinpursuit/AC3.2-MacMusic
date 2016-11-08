//
//  AlbumTracks.swift
//  SpotifySearch
//
//  Created by Cris on 11/7/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum AlbumTrackParseError: Error {
    case name, trackID, trackNumber, trackPreviewURL, response
}

class AlbumTracks {
    let name: String
    let trackID: String
    let trackNumber: Int
    let trackPreviewURL: String
    
    init(name: String, trackID: String, trackNumber: Int, trackPreviewURL: String) {
        self.name = name
        self.trackID = trackID
        self.trackNumber = trackNumber
        self.trackPreviewURL = trackPreviewURL
    }
    
    convenience init?(from Dictionary: [String : Any]) {
        guard let name = Dictionary["name"] as? String,
            let id = Dictionary["id"] as? String,
            let trackNumber = Dictionary["track_number"] as? Int,
            let trackPreviewURL = Dictionary["preview_url"] as? String else { return nil}
        
            self.init(name: name, trackID: id, trackNumber: trackNumber, trackPreviewURL: trackPreviewURL)
    }
    
    static func tracks(from data: Data) -> [AlbumTracks]? {
        var albumTracks: [AlbumTracks] = []
        
        do{
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let response: [String : Any] = jsonData as? [String : Any],
                let trackDicts = response["items"] as? [[String : Any]]
                else {throw AlbumTrackParseError.response}
            
            trackDicts.forEach({ (TrackObject) in
                if let track = AlbumTracks(from: TrackObject) {
                    albumTracks.append(track)
                }
            })
        }
        catch AlbumTrackParseError.response {
            print("ERROR ENCOUNTERED WITH PARSING ITEMS KEY FOR OBJECT")
        }
        catch {
            print("UNKNOWN PARSING ERROR")
        }
        return albumTracks
    }
    
}
