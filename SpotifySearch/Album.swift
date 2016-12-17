//
//  Album.swift
//  SpotifySearch
//
//  Created by Cris on 10/28/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

internal enum AlbumModelParseError: Error {
    case albums, name, smallImageURL, largeImageURL, ID
}

internal struct Album {
    internal let name: String
    internal let smallImageURL: String?
    internal let largeImageURL: String
    internal let albumID: String
    internal let artistID: String
    
    static func albums(from data: Data) -> [Album]? {
        do {
            let albumJSONData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let albumsCasted = albumJSONData as? [String : Any],
                let albumArr = albumsCasted["albums"] as? [String : Any],
                let albums = albumArr["items"] as? [[String:Any]]
                else {throw AlbumModelParseError.albums}
            
            var albumInfo = [Album]()
            
            try albums.forEach({ (albumObject) in
                guard let albumName = albumObject["name"] as? String
                    else {throw AlbumModelParseError.name}
                
                guard let albumID = albumObject["id"] as? String else {throw AlbumModelParseError.ID}
                guard let artistInfo = albumObject["artists"] as? [[String:Any]] else {return}
                guard let artistID = artistInfo[0]["id"] as? String else {return}
                guard let albumImages = albumObject["images"] as? [Any]
                else {throw AlbumModelParseError.smallImageURL}
              
//                guard let albumImages = albumObject["images"] as? [[String: Any]]
//            let albumSmallImageURL = albumImages.count == 0 ? "" : albumImages[2]["url"] as! String
//            let albumLargeImageURL = albumImages.count == 0 ? "" : albumImages[0]["url"] as! String

                guard albumImages.count > 0 else {return}
                let albumSmallImageDict = albumImages[2] as? [String : Any] ?? ["" : ""]
                let albumSmallImageURL = albumSmallImageDict["url"] as? String ?? ""
                
                let albumLargeImageDict = albumImages[0] as? [String : Any] ?? ["" : ""]
                let albumLargeImageURL = albumLargeImageDict["url"] as? String ?? ""
                
                let album = Album(name: albumName, smallImageURL: albumSmallImageURL, largeImageURL: albumLargeImageURL, albumID: albumID, artistID: artistID)

                albumInfo.append(album)
            })
            return albumInfo
        }
        catch {
            print("***** ERROR OCCURED WHILE PARSING DATA: \(error)")
        }
        return nil
    }
}
//
//{
//    "album_type": "album",
//    "artists": [
//    {
//    "external_urls": {
//    "spotify": "https://open.spotify.com/artist/3WGpXCj9YhhfX11TToZcXP"
//    },
//    "href": "https://api.spotify.com/v1/artists/3WGpXCj9YhhfX11TToZcXP",
//    "id": "3WGpXCj9YhhfX11TToZcXP",
//    "name": "Troye Sivan",
//    "type": "artist",
//    "uri": "spotify:artist:3WGpXCj9YhhfX11TToZcXP"
//    }
//    ],
//    "available_markets": [
//    "CA",
//    "MX",
//    "US"
//    ],
//    
//    "external_urls": {
//        "spotify": "https://open.spotify.com/album/5ouTDazE4LF9bVJPx1nlgW"
//    },
//    
//    "href": "https://api.spotify.com/v1/albums/5ouTDazE4LF9bVJPx1nlgW",
//    
//    "id": "5ouTDazE4LF9bVJPx1nlgW",
//    
//    
//    "images": [
//    {
//    "height": 640,
//    "url": "https://i.scdn.co/image/f96947dffe790a60fdf7f2a88549dc4c6f28fcef",
//    "width": 640
//    },
//    {
//    "height": 300,
//    "url": "https://i.scdn.co/image/7a718b371127b1f81971e5fc648e053fbd219a88",
//    "width": 300
//    },
//    {
//    "height": 64,
//    "url": "https://i.scdn.co/image/48513266b48e668a3c57e56daeffcd3582bfdfde",
//    "width": 64
//    }
//    ],
//    
//    
//    "name": "Blue Neighbourhood (Deluxe)",
//    "type": "album",
//    "uri": "spotify:album:5ouTDazE4LF9bVJPx1nlgW"
//}
