//
//  AlbumTracks.swift
//  SpotifySearch
//
//  Created by Cris on 11/7/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum AlbumTrackParseError: Error {
    case artistName, trackName, trackID, trackNumber, trackPreviewURL, response
}

class AlbumTracks {
    let singerName: String
    let trackName: String
    let trackID: String
    let trackNumber: Int
    let trackPreviewURL: String
    let trackLyrics: String
    let albumImg: String
    
    init(singerName: String, trackName: String, trackID: String, trackNumber: Int, trackPreviewURL: String, trackLyrics: String, albumImg: String) {
        self.singerName = singerName
        self.trackName = trackName
        self.trackID = trackID
        self.trackNumber = trackNumber
        self.trackPreviewURL = trackPreviewURL
        self.trackLyrics = trackLyrics
        self.albumImg = albumImg
    }
    
    convenience init?(from Dictionary: [String : Any]) {
        
        
        guard let trackName = Dictionary["name"] as? String, let id = Dictionary["id"] as? String,
            let trackNumber = Dictionary["track_number"] as? Int,
            let trackPreviewURL = Dictionary["preview_url"] as? String else {return nil}
        
        let artistDict = Dictionary["artists"] as? [[String : Any]] ?? [["" : ""]]
        let artistName = artistDict[0]["name"] as? String ?? ""
        let trackLyrics = ""
        let trackImg = ""
        
        
        self.init(singerName: artistName, trackName: trackName, trackID: id, trackNumber: trackNumber, trackPreviewURL: trackPreviewURL, trackLyrics: trackLyrics, albumImg: trackImg)
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
