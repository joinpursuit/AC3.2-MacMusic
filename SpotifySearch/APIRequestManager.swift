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
        
        //      let APIString = "s"
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
}

