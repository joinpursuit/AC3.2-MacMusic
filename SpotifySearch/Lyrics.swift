//
//  File.swift
//  SpotifySearch
//
//  Created by Marcel Chaucer on 11/7/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum LyricsModelParsedError: Error {
    case message
}

class Lyrics {
    let lyricsID: Int
    let lyricsBody: String?
    let lyricsLanguage: String
    let lyricsLanguageDescription: String
    
    init(lyricsID: Int, lyricsBody: String, lyricsLanguage: String, lyricsLanguageDescription: String) {
        self.lyricsID = lyricsID
        self.lyricsBody = lyricsBody
        self.lyricsLanguage = lyricsLanguage
        self.lyricsLanguageDescription = lyricsLanguageDescription
    }
    
    convenience init?(withDict dict: [String:Any]) {
        if let lyricsID = dict["lyrics_id"] as? Int,
            let lyricsBody = dict["lyrics_body"] as? String,
            let lyricsLanguage = dict["lyrics_language"] as? String,
            let lyricsLanguageDescription = dict["lyrics_language_description"] as? String
            
        {
            self.init(lyricsID: lyricsID, lyricsBody: lyricsBody, lyricsLanguage: lyricsLanguage, lyricsLanguageDescription: lyricsLanguageDescription)
        }
        else {
            return nil
        }
    }

    
    static func getInfo(from data: Data) -> [Lyrics]? {
        var infoToReturn: [Lyrics]? = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jSon = jsonData as? [String:Any] else { return nil}
            
            guard let message = jSon["message"] as? [String: Any],
            let body = message["body"] as? [String: Any],
            let lyrics = body["lyrics"] as? [String: Any] else {throw LyricsModelParsedError.message}
            
            if let theLyrics = Lyrics(withDict: lyrics) {
                infoToReturn?.append(theLyrics)
            }
        }
        catch {
            print("Unknown parsing error")
        }
        
        return infoToReturn
    }
}

