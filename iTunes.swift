//
//  iTunes.swift
//  SpotifySearch
//
//  Created by Ana Ma on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum iTunesModelParseError: Error {
    case results
    case artistId
    case result
    case collectionId
    case trackId
    case artistName
    case collectionName
    case trackName
    case trackCensoredName
    case artistViewUrl
    case collectionViewUrl
    case trackViewUrl
    case collectionPrice
    case trackPrice
    case releaseDate
}

class iTunes {
    //https://itunes.apple.com/search?country=US&media=music&entity=musicTrack&term=gem ainy
    var artistName: String
    var trackName: String
    var trackViewUrl: String
    init (
          artistName: String,
          trackName: String,
          trackViewUrl: String){
        self.artistName = artistName
        self.trackName = trackName
        self.trackViewUrl = trackViewUrl
    }
    
    static func getiTunes (from data: Data) -> [iTunes]? {
        var iTunesToReturn: [iTunes]? = []
        do{
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = jsonData as? [String: Any] else {
                throw TrackModelParseError.dictionary
            }
            guard let results = dictionary["results"] as? [[String: Any]] else {
                throw iTunesModelParseError.results
            }
            
            try results.forEach({ (result) in
                guard let artistName = result["artistName"] as? String else {
                    throw iTunesModelParseError.artistName
                }
                guard let trackName = result["trackName"] as? String else {
                    throw iTunesModelParseError.trackName
                }
                guard let trackViewUrl = result["trackViewUrl"] as? String else {
                    throw iTunesModelParseError.trackViewUrl
                }
                let i = iTunes(artistName: artistName, trackName: trackName, trackViewUrl: trackViewUrl)
                iTunesToReturn?.append(i)
            })
            //dump(iTunesToReturn)
            //dump(jsonData)
        }
        catch iTunesModelParseError.result {
            print("there's error in result")
        }
        catch{
            print("there's error")
        }
        return iTunesToReturn
    }
}
/*
 {
 "wrapperType": "track",
 "kind": "song",
 "artistId": 425208570,
 "collectionId": 623244518,
 "trackId": 623244605,
 "artistName": "G.E.M.",
 "collectionName": "The Best of G.E.M. 2008-2012",
 "trackName": "A.I.N.Y.",
 "collectionCensoredName": "The Best of G.E.M. 2008-2012",
 "trackCensoredName": "A.I.N.Y.",
 "artistViewUrl": "https://itunes.apple.com/us/artist/g.e.m./id425208570?uo=4",
 "collectionViewUrl": "https://itunes.apple.com/us/album/a.i.n.y./id623244518?i=623244605&uo=4",
 "trackViewUrl": "https://itunes.apple.com/us/album/a.i.n.y./id623244518?i=623244605&uo=4",
 "previewUrl": "http://a519.phobos.apple.com/us/r30/Music/v4/47/c1/5e/47c15e7d-eefd-b37c-d640-1090039b5a26/mzaf_1942857753794734609.aac.m4a",
 "artworkUrl30": "http://is2.mzstatic.com/image/thumb/Music/v4/f4/9a/14/f49a1493-3173-5637-9dd6-9f91dd51ddc9/source/30x30bb.jpg",
 "artworkUrl60": "http://is2.mzstatic.com/image/thumb/Music/v4/f4/9a/14/f49a1493-3173-5637-9dd6-9f91dd51ddc9/source/60x60bb.jpg",
 "artworkUrl100": "http://is2.mzstatic.com/image/thumb/Music/v4/f4/9a/14/f49a1493-3173-5637-9dd6-9f91dd51ddc9/source/100x100bb.jpg",
 "collectionPrice": 12.99,
 "trackPrice": 0.99,
 "releaseDate": "2013-03-27T07:00:00Z",
 "collectionExplicitness": "notExplicit",
 "trackExplicitness": "notExplicit",
 "discCount": 1,
 "discNumber": 1,
 "trackCount": 24,
 "trackNumber": 1,
 "trackTimeMillis": 226813,
 "country": "USA",
 "currency": "USD",
 "primaryGenreName": "Mandopop",
 "isStreamable": true
 }*/
/*
class iTunes {
    //https://itunes.apple.com/search?country=US&media=music&entity=musicTrack&term=gem ainy
    //    var artistId: Int
    //    var collectionId: Int
    //    var trackId: Int
    var artistName: String
    //    var collectionName: String
    var trackName: String
    //    var trackCensoredName: String
    //    var artistViewUrl: String
    //    var collectionViewUrl: String
    var trackViewUrl: String
    //    var collectionPrice: Double
    var trackPrice: Double
    var releaseDate: String
    
    init (
        //          artistId: Int,
        //          collectionId: Int,
        //          trackId: Int,
        artistName: String,
        //          collectionName: String,
        trackName: String,
        //          trackCensoredName: String,
        //          artistViewUrl: String,
        //          collectionViewUrl: String,
        trackViewUrl: String,
        //          collectionPrice: Double,
        trackPrice: Double,
        releaseDate: String) {
        //        self.artistId = artistId
        //        self.collectionId = collectionId
        //        self.trackId = trackId
        self.artistName = artistName
        //        self.collectionName = collectionName
        self.trackName = trackName
        //        self.trackCensoredName = trackCensoredName
        //        self.artistViewUrl = artistViewUrl
        //        self.artistViewUrl = artistViewUrl
        //        self.collectionViewUrl = collectionViewUrl
        self.trackViewUrl = trackViewUrl
        //        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.releaseDate = releaseDate
    }
    
    static func getiTunes (from data: Data) -> [iTunes]? {
        var iTunesToReturn: [iTunes]? = []
        do{
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = jsonData as? [String: Any] else {
                throw TrackModelParseError.dictionary
            }
            guard let results = dictionary["results"] as? [[String: Any]] else {
                throw iTunesModelParseError.results
            }
            
            //            guard let albumsCasted = albumJSONData as? [String : Any],
            //                let albumArr = albumsCasted["albums"] as? [String : Any],
            //                let albums = albumArr["items"] as? [[String:Any]]
            //                else {throw AlbumModelParseError.albums}
            
            try results.forEach({ (result) in
                guard let artistID = result["artistId"] as? Int else {
                    throw iTunesModelParseError.artistId
                }
                
                guard let collectionId = result["collectionId"] as? Int else {
                    throw iTunesModelParseError.collectionId
                }
                
                guard let trackId = result["trackId"] as? Int else {
                    throw iTunesModelParseError.trackId
                }
                
                guard let artistName = result["artistName"] as? String else {
                    throw iTunesModelParseError.artistName
                }
                
                guard let collectionName = result["collectionName"] as? String else {
                    throw iTunesModelParseError.collectionName
                }
                
                guard let trackName = result["trackName"] as? String else {
                    throw iTunesModelParseError.trackName
                }
                
                guard let trackCensoredName = result["trackCensoredName"] as? String else {
                    throw iTunesModelParseError.trackCensoredName
                }
                
                guard let artistViewUrl = result["artistViewUrl"] as? String else {
                    throw iTunesModelParseError.artistViewUrl
                }
                
                guard let collectionViewUrl = result["collectionViewUrl"] as?  String else {
                    throw iTunesModelParseError.collectionViewUrl
                }
                
                guard let trackViewUrl = result["trackViewUrl"] as? String else {
                    throw iTunesModelParseError.trackViewUrl
                }
                
                guard  let collectionPrice = result["collectionPrice"] as? Double else {
                    throw iTunesModelParseError.collectionPrice
                }
                
                guard  let trackPrice = result["trackPrice"] as? Double else {
                    throw iTunesModelParseError.trackPrice
                }
                
                guard    let releaseDate = result["releaseDate"] as? String else {
                    throw iTunesModelParseError.releaseDate
                }
                
                let i = iTunes(artistName: artistName, trackName: trackName, trackViewUrl: trackViewUrl, trackPrice: trackPrice, releaseDate: releaseDate)
                iTunesToReturn?.append(i)
            })
            dump(iTunesToReturn)
            //dump(jsonData)
        }
        catch iTunesModelParseError.result {
            print("there's error in result")
        }
        catch{
            print("there's error")
        }
        return iTunesToReturn
    }
}
*/
