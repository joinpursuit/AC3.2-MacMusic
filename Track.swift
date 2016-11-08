//
//  Track.swift
//  SpotifySearch
//
//  Created by Ana Ma on 11/8/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum TrackModelParseError: Error {
    case dictionary
    case message
    case body
    case track_list
    case trackDetail
    case track_id
    case track_mbid
    case track_name
    case track_rating
    case track_length
    case commontrack_id
    case has_lyrics
    case has_subtitles
    case num_favourite
    case lyrics_id
    case subtitle_id
    case album_id
    case album_name
    case artist_id
    case artist_mbid
    case artist_name
    case album_coverart_100x100
    case track_share_url
    case track_edit_url
    case commontrack_vanity_id
    case first_release_date
    case updated_time
    case primary_genres
    case genre
    case music_genre_list
    case music_genre_name
    
}

class Track {
    //http://api.musixmatch.com/ws/1.1/track.search?apikey=a94099f771b956511ae7b523023eea65&q_track=Complicated&q_artist=Avril&page_size=10
    var track_id: Int
    var track_mbid: String
    var track_name: String
    var track_rating: Int
    var track_length: Int
    var commontrack_id: Int
    var has_lyrics: Int
    var has_subtitles: Int
    var num_favourite: Int
    var lyrics_id: Int
    var subtitle_id: Int
    var album_id: Int
    var album_name: String
    var artist_id: Int
    var artist_mbid: String
    var artist_name: String
    var album_coverart_100x100: String
    var track_share_url: String
    var track_edit_url: String
    var commontrack_vanity_id: String
    var first_release_date: String
    var updated_time: String
    var genre: [Genre]
    
    init (track_id: Int,
          track_mbid: String,
          track_name: String,
          track_rating: Int,
          track_length: Int,
          commontrack_id: Int,
          has_lyrics: Int,
          has_subtitles: Int,
          num_favourite: Int,
          lyrics_id: Int,
          subtitle_id: Int,
          album_id: Int,
          album_name: String,
          artist_id: Int,
          artist_mbid: String,
          artist_name: String,
          album_coverart_100x100: String,
          track_share_url: String,
          track_edit_url: String,
          commontrack_vanity_id: String,
          first_release_date: String,
          updated_time: String,
          genre: [Genre]){
        
        self.track_id = track_id
        self.track_mbid = track_mbid
        self.track_name = track_name
        self.track_rating = track_rating
        self.track_length = track_length
        self.commontrack_id = commontrack_id
        self.has_lyrics = has_lyrics
        self.has_subtitles = has_subtitles
        self.num_favourite = num_favourite
        self.lyrics_id = lyrics_id
        self.subtitle_id = subtitle_id
        self.album_id = album_id
        self.album_name = album_name
        self.artist_id = artist_id
        self.artist_mbid = artist_mbid
        self.artist_name = artist_name
        self.album_coverart_100x100 = album_coverart_100x100
        self.track_share_url = track_share_url
        self.track_edit_url = track_edit_url
        self.commontrack_vanity_id = commontrack_vanity_id
        self.first_release_date = first_release_date
        self.updated_time = updated_time
        self.genre = genre
        
    }
    
    static func getTrack (from data: Data) -> [Track]? {
        var trackToReturn: [Track]? = []
        var genreArray: [Genre] = []
        do{
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = jsonData as? [String: Any] else {
                throw TrackModelParseError.dictionary
            }
            guard let message = dictionary["message"] as? [String: Any] else {
                throw TrackModelParseError.message
            }
            guard let body = message["body"] as? [String: Any] else {
                throw TrackModelParseError.body
            }
            guard let track_list = body["track_list"] as? [[String:Any]] else {
                throw TrackModelParseError.track_list
            }
            for track in track_list {
                guard let trackDetail = track["track"] as? [String:Any] else {
                    throw TrackModelParseError.trackDetail
                }
                guard let track_id = trackDetail["track_id"] as? Int else {
                    throw TrackModelParseError.track_id
                }
                guard let track_mbid = trackDetail["track_mbid"] as? String else {
                    throw TrackModelParseError.track_mbid
                }
                guard let track_name = trackDetail["track_name"] as? String else {
                    throw TrackModelParseError.track_name
                }
                guard let track_rating = trackDetail["track_rating"] as? Int else {
                    throw TrackModelParseError.track_rating
                }
                guard let track_length = trackDetail["track_length"] as? Int else {
                    throw TrackModelParseError.track_length
                }
                guard let commontrack_id = trackDetail["commontrack_id"] as? Int else {
                    throw TrackModelParseError.commontrack_id
                }
                guard let has_lyrics = trackDetail["has_lyrics"] as? Int else {
                    throw TrackModelParseError.has_lyrics
                }
                guard let has_subtitles = trackDetail["has_subtitles"] as? Int else {
                    throw TrackModelParseError.has_subtitles
                }
                guard let num_favourite = trackDetail["num_favourite"] as? Int else {
                    throw TrackModelParseError.num_favourite
                }
                guard let lyrics_id = trackDetail["lyrics_id"] as? Int else {
                    throw TrackModelParseError.lyrics_id
                }
                guard let subtitle_id = trackDetail["subtitle_id"] as? Int else {
                    throw TrackModelParseError.subtitle_id
                }
                guard let album_id = trackDetail["album_id"] as? Int else {
                    throw TrackModelParseError.album_id
                }
                guard let album_name = trackDetail["album_name"] as? String else {
                    throw TrackModelParseError.album_name
                }
                guard let artist_id = trackDetail["artist_id"] as? Int else {
                    throw TrackModelParseError.artist_id
                }
                guard let artist_mbid = trackDetail["artist_mbid"] as? String else {
                    throw TrackModelParseError.artist_mbid
                }
                guard let artist_name = trackDetail["artist_name"] as? String else {
                    throw TrackModelParseError.artist_name
                }
                guard let album_coverart_100x100 = trackDetail["album_coverart_100x100"] as? String else {
                    throw TrackModelParseError.album_coverart_100x100
                }
                guard let track_share_url = trackDetail["track_share_url"] as? String else {
                    throw TrackModelParseError.track_share_url
                }
                guard let track_edit_url = trackDetail["track_edit_url"] as? String else {
                    throw TrackModelParseError.track_edit_url
                }
                guard let commontrack_vanity_id = trackDetail["commontrack_vanity_id"] as? String else {
                    throw TrackModelParseError.commontrack_vanity_id
                }
                guard let first_release_date = trackDetail["first_release_date"] as? String else {
                    throw TrackModelParseError.first_release_date
                }
                guard let updated_time = trackDetail["updated_time"] as? String else {
                    throw TrackModelParseError.updated_time
                }
                
                if let primary_genres = trackDetail["primary_genres"] as? [String:Any],
                    let music_genre_list = primary_genres["music_genre_list"] as? [[String: Any]] {
                    for list in music_genre_list {
                        if let g = Genre(from: list) {
                            genreArray.append(g)
                        }
                    }
                }
                let t = Track(track_id: track_id, track_mbid: track_mbid, track_name: track_name, track_rating: track_rating, track_length: track_length, commontrack_id: commontrack_id, has_lyrics: has_lyrics, has_subtitles: has_subtitles, num_favourite: num_favourite, lyrics_id: lyrics_id, subtitle_id: subtitle_id, album_id: album_id, album_name: album_name, artist_id: artist_id, artist_mbid: artist_mbid, artist_name: artist_name, album_coverart_100x100: album_coverart_100x100, track_share_url: track_share_url, track_edit_url: track_edit_url, commontrack_vanity_id: commontrack_vanity_id, first_release_date: first_release_date, updated_time: updated_time, genre: genreArray)
                trackToReturn?.append(t)
                
            }
            //dump(jsonData)
        }
        catch{
            print("there's error")
        }
        return trackToReturn
    }
}

