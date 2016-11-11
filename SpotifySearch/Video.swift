//
//  Video.swift
//  SpotifySearch
//
//  Created by Ana Ma on 11/10/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum VideoModelParseError: Error {
    case dictionary
    case items
    case id
    case videoId
    case snippet
    case title
    case description
    case channelTitle
}

class Video {
    var videoId: String
    var title: String
    var description: String
    var channelTitle: String
    
    init(videoId: String, title: String, description: String, channelTitle: String) {
        self.videoId = videoId
        self.title = title
        self.description = description
        self.channelTitle = channelTitle
    }
    
    static func getVideo(from data: Data) -> [Video]? {
        var videosToReturn = [Video]()
        
        do{
            let jsonData : Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = jsonData as? [String:Any] else {
                throw VideoModelParseError.dictionary
            }
            
            guard let items = dictionary["items"] as? [[String: Any]] else {
                throw VideoModelParseError.items
            }
            
            try items.forEach({ (item) in
                guard let id = item["id"] as? [String : Any] else {
                    throw VideoModelParseError.id
                }
                
                guard let videoId = id["videoId"] as? String else {
                    throw VideoModelParseError.videoId
                }
                
                guard let snippet = item["snippet"] as? [String: Any] else {
                    throw VideoModelParseError.snippet
                }
                
                guard let title = snippet["title"] as? String,
                    let description = snippet["description"] as? String,
                    let channelTitle = snippet["channelTitle"] as? String else {
                    throw VideoModelParseError.title
                    throw VideoModelParseError.description
                    throw VideoModelParseError.channelTitle
                }
                
                let v = Video(videoId: videoId, title: title, description: description, channelTitle: channelTitle)
                videosToReturn.append(v)
                
            })
            
        }
        catch {
            print(error)
        }
        
        return videosToReturn
    }
    
}
/*
 {
 "kind": "youtube#searchListResponse",
 "etag": "\"sZ5p5Mo8dPpfIzLYQBF8QIQJym0/-9s6F7q4L84OT39Fy3zfWuZc32g\"",
 "nextPageToken": "CAUQAA",
 "regionCode": "US",
 "pageInfo": {
 "totalResults": 83109,
 "resultsPerPage": 5
 },
 "items": [
 {
 "kind": "youtube#searchResult",
 "etag": "\"sZ5p5Mo8dPpfIzLYQBF8QIQJym0/j0uEstXCXOhrDqDegEBmEeHqsBM\"",
 "id": {
 "kind": "youtube#video",
 "videoId": "YQHsXMglC9A"
 },
 "snippet": {
 "publishedAt": "2015-10-23T06:54:18.000Z",
 "channelId": "UComP_epzeKzvBX156r6pm1Q",
 "title": "Adele - Hello",
 "description": "'Hello' is taken from the new album, 25, out November 20. http://adele.com Available now from iTunes http://smarturl.it/itunes25 Available now from Amazon ...",
 "thumbnails": {
 "default": {
 "url": "https://i.ytimg.com/vi/YQHsXMglC9A/default.jpg",
 "width": 120,
 "height": 90
 },
 "medium": {
 "url": "https://i.ytimg.com/vi/YQHsXMglC9A/mqdefault.jpg",
 "width": 320,
 "height": 180
 },
 "high": {
 "url": "https://i.ytimg.com/vi/YQHsXMglC9A/hqdefault.jpg",
 "width": 480,
 "height": 360
 }
 },
 "channelTitle": "AdeleVEVO",
 "liveBroadcastContent": "none"
 }
 },
 {
 "kind": "youtube#searchResult",
 "etag": "\"sZ5p5Mo8dPpfIzLYQBF8QIQJym0/eENmars3S-do59P34mwq71_HDsY\"",
 "id": {
 "kind": "youtube#video",
 "videoId": "fk4BbF7B29w"
 },
 "snippet": {
 "publishedAt": "2016-05-23T01:46:00.000Z",
 "channelId": "UComP_epzeKzvBX156r6pm1Q",
 "title": "Adele - Send My Love (To Your New Lover)",
 "description": "'Send My Love (To Your New Lover)' is taken from the new album, 25, out now. http://adele.com Available now from iTunes http://smarturl.it/itunes25 Available ...",
 "thumbnails": {
 "default": {
 "url": "https://i.ytimg.com/vi/fk4BbF7B29w/default.jpg",
 "width": 120,
 "height": 90
 },
 "medium": {
 "url": "https://i.ytimg.com/vi/fk4BbF7B29w/mqdefault.jpg",
 "width": 320,
 "height": 180
 },
 "high": {
 "url": "https://i.ytimg.com/vi/fk4BbF7B29w/hqdefault.jpg",
 "width": 480,
 "height": 360
 }
 },
 "channelTitle": "AdeleVEVO",
 "liveBroadcastContent": "none"
 }
 },
 {
 "kind": "youtube#searchResult",
 "etag": "\"sZ5p5Mo8dPpfIzLYQBF8QIQJym0/qJEV3XUjJ6PUaYgQkLUrbGfOnYA\"",
 "id": {
 "kind": "youtube#video",
 "videoId": "DDWKuo3gXMQ"
 },
 "snippet": {
 "publishedAt": "2015-11-17T08:00:00.000Z",
 "channelId": "UComP_epzeKzvBX156r6pm1Q",
 "title": "Adele - When We Were Young (Live at The Church Studios)",
 "description": "'When We Were Young' is taken from the new album, 25, released November 20. http://adele.com Available now from iTunes http://smarturl.it/itunes25 Available ...",
 "thumbnails": {
 "default": {
 "url": "https://i.ytimg.com/vi/DDWKuo3gXMQ/default.jpg",
 "width": 120,
 "height": 90
 },
 "medium": {
 "url": "https://i.ytimg.com/vi/DDWKuo3gXMQ/mqdefault.jpg",
 "width": 320,
 "height": 180
 },
 "high": {
 "url": "https://i.ytimg.com/vi/DDWKuo3gXMQ/hqdefault.jpg",
 "width": 480,
 "height": 360
 }
 },
 "channelTitle": "AdeleVEVO",
 "liveBroadcastContent": "none"
 }
 },
 {
 "kind": "youtube#searchResult",
 "etag": "\"sZ5p5Mo8dPpfIzLYQBF8QIQJym0/r-OvrJSHkfi91qQZUwMeRS7mwEQ\"",
 "id": {
 "kind": "youtube#video",
 "videoId": "Nck6BZga7TQ"
 },
 "snippet": {
 "publishedAt": "2016-01-14T06:09:24.000Z",
 "channelId": "UCJ0uqCI0Vqr2Rrt1HseGirg",
 "title": "Adele Carpool Karaoke",
 "description": "While home in London for the holidays, James Corden picks up his friend Adele for a drive around the city singing some of her classic songs before Adele raps ...",
 "thumbnails": {
 "default": {
 "url": "https://i.ytimg.com/vi/Nck6BZga7TQ/default.jpg",
 "width": 120,
 "height": 90
 },
 "medium": {
 "url": "https://i.ytimg.com/vi/Nck6BZga7TQ/mqdefault.jpg",
 "width": 320,
 "height": 180
 },
 "high": {
 "url": "https://i.ytimg.com/vi/Nck6BZga7TQ/hqdefault.jpg",
 "width": 480,
 "height": 360
 }
 },
 "channelTitle": "The Late Late Show with James Corden",
 "liveBroadcastContent": "none"
 }
 },
 {
 "kind": "youtube#searchResult",
 "etag": "\"sZ5p5Mo8dPpfIzLYQBF8QIQJym0/jQeBQKAwcVSP2PbaNoaXCaeagFs\"",
 "id": {
 "kind": "youtube#video",
 "videoId": "DfG6VKnjrVw"
 },
 "snippet": {
 "publishedAt": "2015-11-09T19:50:38.000Z",
 "channelId": "UComP_epzeKzvBX156r6pm1Q",
 "title": "Adele - Hello (Live at the NRJ Awards)",
 "description": "'Hello' is taken from the new album, 25, out November 20. http://adele.com Available now from iTunes http://smarturl.it/itunes25 Available now from Amazon ...",
 "thumbnails": {
 "default": {
 "url": "https://i.ytimg.com/vi/DfG6VKnjrVw/default.jpg",
 "width": 120,
 "height": 90
 },
 "medium": {
 "url": "https://i.ytimg.com/vi/DfG6VKnjrVw/mqdefault.jpg",
 "width": 320,
 "height": 180
 },
 "high": {
 "url": "https://i.ytimg.com/vi/DfG6VKnjrVw/hqdefault.jpg",
 "width": 480,
 "height": 360
 }
 },
 "channelTitle": "AdeleVEVO",
 "liveBroadcastContent": "none"
 }
 }
 ]
 }
 */
