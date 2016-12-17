//
//  User.swift
//  SpotifySearch
//
//  Created by Ana Ma on 12/14/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum UserModelParseError: Error {
    case display_name
    case id
    case href
    case user
}

class User {
    let display_name : String?
    let id : String
    let href: String
    
    init(display_name : String?,
        id : String,
        href: String) {
        self.display_name = display_name
        self.id = id
        self.href = href
    }
    
    convenience init? (dict: [String:AnyObject]) throws {
        let display_name = dict["display_name"] as? String
        guard let id = dict["id"] as? String else {
            throw UserModelParseError.id
        }
        guard let href = dict["href"] as? String else {
            throw UserModelParseError.href
        }
        self.init(display_name : display_name,
                  id : id,
                  href: href)
    }
    
}
