//
//  SettingsManager.swift
//  SpotifySearch
//
//  Created by Cris on 10/30/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum albumType {
    case album, artist, track, playlist
}

enum albumMarket {
  case AD, AR, AT, AU, BE, BG, BO, BR, CH, CL, CO, CR, CY, CZ, DE, DK, DO, EC, EE, ES, FI, FR, GB, US, MX
}

class SettingsManager: slideCellDelegate, SegmentedControlDelegate {
    
    var limit: Int
    var type: albumType
    var market: albumMarket
    
    let minResults = 1
    let maxResults = 50
    
    static let manager: SettingsManager = SettingsManager()
    
    private init() {
        self.limit = maxResults
        self.type = .album
        self.market = .US
    }
    
    func updateNumberOfresults(_ numOfResults: Int) {
        if numOfResults < minResults {
            self.limit = minResults
        } else if numOfResults > maxResults {
            self.limit = maxResults
        } else {
            self.limit = numOfResults
        }
    }
    
    func sliderDidChange(_ value: Int) {
        updateNumberOfresults(value)
    }
    
    func didSelectMusicType(ofType: albumType) {
        self.type = ofType
    }
    
}
