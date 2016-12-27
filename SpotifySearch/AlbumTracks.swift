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
        //need to do another convenience init just to make things work
        //track is one level deeper
        //https://api.spotify.com/v1/me/tracks
        //Authorization Bearer BQCpLpruFbe...
        
        guard let trackName = Dictionary["name"] as? String, let id = Dictionary["id"] as? String,
            let trackNumber = Dictionary["track_number"] as? Int,
            let trackPreviewURL = Dictionary["preview_url"] as? String else {return nil}
        
        let artistDict = Dictionary["artists"] as? [[String : Any]] ?? [["" : ""]]
        let artistName = artistDict[0]["name"] as? String ?? ""
        let trackLyrics = ""
        let trackImg = ""
        
        
        self.init(singerName: artistName, trackName: trackName, trackID: id, trackNumber: trackNumber, trackPreviewURL: trackPreviewURL, trackLyrics: trackLyrics, albumImg: trackImg)
    }
    
    convenience init?(fromFavorite dictionary: [String: Any]) {
        guard let track = dictionary["track"] as? [String: Any],
            let trackName = track["name"] as? String,
            let id = track["id"] as? String,
            let trackNumber = track["track_number"] as? Int,
            let trackPreviewURL = track["preview_url"] as? String else {return nil}
        
        let artistDict = track["artists"] as? [[String : Any]] ?? [["" : ""]]
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
    
    static func tracks(fromFavorite data: Data) -> [AlbumTracks]? {
        var albumTracks: [AlbumTracks] = []
        
        do{
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let response: [String : Any] = jsonData as? [String : Any],
                let trackDicts = response["items"] as? [[String : Any]]
                else {throw AlbumTrackParseError.response}
            dump(response)
            
            trackDicts.forEach({ (TrackObject) in
                if let track = AlbumTracks(fromFavorite: TrackObject) {
                    albumTracks.append(track)
                    let userDefaults = UserDefaults.standard
                    //if let favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
                        //for song in favoriteSongs {
                            //if song["track_id"] == track.trackID {
                                //let userDefaults = UserDefaults.standard
                                var favoriteSong = [String: String]()
                                favoriteSong.updateValue(track.trackID, forKey: "track_id")
                                favoriteSong.updateValue(track.trackName, forKey: "track_name")
                                favoriteSong.updateValue(track.singerName, forKey: "artist_name")
                                //favoriteSong.updateValue(String(trackID), forKey: "track_lyrics_id")
                                favoriteSong.updateValue(String(track.trackNumber), forKey: "track_number")
                                favoriteSong.updateValue(track.trackPreviewURL, forKey: "track_preview_URL")
                                favoriteSong.updateValue(track.albumImg, forKey: "album_Img")
                                
                                if var favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
                                    favoriteSongs.append(favoriteSong)
                                    userDefaults.set(favoriteSongs, forKey: "favoriteSongs")
                                } else {
                                    userDefaults.set([favoriteSong], forKey: "favoriteSongs")
                                }

                            //}
                        //}
                    //}
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
