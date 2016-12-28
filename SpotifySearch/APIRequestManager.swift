//
//  APIRequestManager.swift
//  SpotifySearch
//
//  Created by Cris on 10/28/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let manager: APIRequestManager = APIRequestManager()
    init() {}
    
    
    func getAlbumsUsingAPI(artist: String = "Kanye", type: String = "album", market: String = "US", completion:@escaping ((Data?)->Void)) {
        
        guard let searchArtist = artist.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        let APIString = "https://api.spotify.com/v1/search?q=\(searchArtist)&type=\(SettingsManager.manager.type)&market=\(market)&limit=\(SettingsManager.manager.limit)"
        let APIURL = URL(string: APIString)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: APIURL!) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered!: \(error!)")
            }
            if let validData: Data = data {
                print(validData)
                completion(validData)
            }
            }.resume()
    }
    
    func getTracksUsingAPI(trackID: String, completion:@escaping ((Data?)->Void)) {
        
        let APIString = "https://api.spotify.com/v1/albums/\(trackID)/tracks"
        let APIURL = URL(string: APIString)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: APIURL!) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered!: \(error!)")
            }
            if let validData: Data = data {
                print(validData)
                completion(validData)
            }
            }.resume()
    }
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
    var trackBaseURL = "http://api.musixmatch.com/ws/1.1/track.search?apikey=a94099f771b956511ae7b523023eea65"
    var trackURL = ""
    
    var lyricsBaseURL = "http://api.musixmatch.com/ws/1.1/track.lyrics.get?apikey=c4c49544dec7305a9c6a01af96bfdcb3&track_id="
    var lyricsURL = ""
    
    
    func getiTunesMusicData(track: AlbumTracks, callback: @escaping ([iTunes]?) -> Void) {
//        guard let searchiTunesName: String = track.trackName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
//        guard let searchiTunesSinger: String = track.singerName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let validSearchString = (track.trackName + " " + track.singerName).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let iTunesBaseURL = "https://itunes.apple.com/search?country=US&media=music&entity=musicTrack"
//        let iTunesURL = iTunesBaseURL + "&term=" + searchiTunesName + "%20" + searchiTunesSinger
        let iTunesURL = iTunesBaseURL + "&term=" + validSearchString
        print(iTunesURL)
        //http://stackoverflow.com/questions/433907/how-to-link-to-apps-on-the-app-store
        APIRequestManager.manager.getData(endPoint: iTunesURL) { (data: Data?) in
            guard let validData = data else {return}
            guard let validiTunes = iTunes.getiTunes(from: validData) else {return}
            callback(validiTunes)
        }
    }
    
    
    func getYouTubeVevoData(track: AlbumTracks, callback: @escaping ([Video]?) -> Void) {
        let videoBaseURL = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyAtF36hcFVY9F8ZetEbSLvXVzeu1RtJzD8&order=viewCount&part=snippet&type=video"
        var videoURL = ""
        let searchString = track.singerName + " " + track.trackName
        guard let validSearchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        //let searchStringWithPlus = searchString.replacingOccurrences(of: " ", with: "+")
        videoURL = videoBaseURL + "&q=" + validSearchString
        print(videoURL)
        APIRequestManager.manager.getData(endPoint: videoURL) { (data: Data?) in
            dump(data)
            if let validData = data{
                dump(validData)
                guard let validVideos = Video.getVideo(from: validData) else {return}
                callback(validVideos)
            }
        }
        //https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=nicki+minaj+anaconda&type=video&key=AIzaSyAtF36hcFVY9F8ZetEbSLvXVzeu1RtJzD8
        //https://www.youtube.com/watch?v=LDZX4ooRsWs

    }
}

