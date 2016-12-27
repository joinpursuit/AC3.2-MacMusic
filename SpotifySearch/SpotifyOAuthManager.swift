//
//  SpotifyOAuthManager.swift
//  SpotifySearch
//
//  Created by Ana Ma on 12/14/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation
import UIKit

//https://developer.spotify.com/web-api/authorization-guide/

enum SpotifyScope: String {
    case user_library_read, user_library_modify
}

enum ParseError: Error {
    case access_token
    case user
}

internal class SpotifyOAuthManager {
    // auth_code part
    static let authorizationURL: URL = URL(string: "https://accounts.spotify.com/authorize")!
    static let redirectURL: URL = URL(string: "macmusic://auth.url")!
    
    // auth_token part
    static let accessTokenURL: URL = URL(string: "https://accounts.spotify.com/api/token")!
    
    // access Spotify WebAPI
    static let accessSpotifyAPI: URL = URL(string: "https://api.spotify.com/v1/me")!
    
    
    // keep reference to values we may need to use later
    private var clientID: String?
    private var clientSecret: String?
    private var accessToken: String?
    private var userID: String?
    //private var responseType: String?
    
    // singleton
    internal static let shared: SpotifyOAuthManager = SpotifyOAuthManager()
    private init () {}
    
    // Class function to set up our manager (code design purely)
    // Called function to set id and secret to the SpotifyOAuthManager Singleton Property: clientID and clientSecret
    internal class func configure(clientID: String, clientSecret: String) {
        shared.clientID = clientID
        shared.clientSecret = clientSecret
    }
    
    internal class func configure(clientID: String, clientSecret: String, accessToken: String) {
        shared.clientID = clientID
        shared.clientSecret = clientSecret
        shared.accessToken = accessToken
    }
    
    func requestAuthorization(scopes: [SpotifyScope]) throws {
        guard let clientID = self.clientID,
            let clientSecret = self.clientSecret
            else {
                throw NSError(domain: "Client ID/ Client Secret not set", code: 1, userInfo: nil)
        }
        //Look Up URLQUeryItem, giving the address of where to get the information from
        let clientIDQuery = URLQueryItem(name: "client_id", value: clientID)
        let redirectURLQuery = URLQueryItem(name: "redirect_uri", value: SpotifyOAuthManager.redirectURL.absoluteString)
        let responseTypeURLQuery = URLQueryItem(name: "response_type", value: "token")
        let scopeQuery : URLQueryItem = URLQueryItem(name: "scope", value: scopes.flatMap{$0.rawValue.replacingOccurrences(of: "_", with: "-")}.joined(separator: " "))
        
        var components = URLComponents(url: SpotifyOAuthManager.authorizationURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [clientIDQuery, responseTypeURLQuery, redirectURLQuery, scopeQuery]
        
        print(components!.url!.absoluteString)
        
        //https://accounts.spotify.com/authorize?client_id=**************&response_type=token&redirect_uri=macmusic://auth.url&scope=user-library-read%20user-library-modify
        UIApplication.shared.open(components!.url!, options: [:], completionHandler: nil)

    }
    
    func requestAuthToken(url: URL) {
        print("[This is the url for requestAuthToken:  \(url)]")
        //[This is the url for requestAuthToken:  macmusic://auth.url/#access_token=**********&token_type=Bearer&expires_in=3600]
        let arrayOfString = url.absoluteString.components(separatedBy: "=")
        let accessToken = arrayOfString[1].components(separatedBy: "&")[0]
        self.accessToken = accessToken
        print(accessToken)
        
        var authTokenRequest = URLRequest(url: url)
        authTokenRequest.httpMethod = "POST"
        authTokenRequest.addValue("Basic <base64 encoded \(self.clientID):\(self.clientSecret)>", forHTTPHeaderField: "Authorization")
        let grandTypeQuery = URLQueryItem(name: "grant_type", value: "authorization_code")
        let redirectURLQuery = URLQueryItem(name: "redirect_uri", value: SpotifyOAuthManager.redirectURL.absoluteString)
        let codeQuery = URLQueryItem(name: "code", value: self.accessToken)
        
        var components = URLComponents(url: SpotifyOAuthManager.accessTokenURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [grandTypeQuery, redirectURLQuery, codeQuery]
        
        print(components!.url!.absoluteString)
        
        var request = URLRequest(url: SpotifyOAuthManager.accessSpotifyAPI)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // launch our URLSession
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error)
            }
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            if data != nil {
                print(data!)
                dump(data!)
                do {
                    //Get accessToken as String
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    if let validJson = json as? [String: AnyObject] {
                        guard let validUser = try User(dict: validJson) else {
                            throw ParseError.user
                        }
                        self.userID = validUser.id
                        let notificationCenter = NotificationCenter.default
                        notificationCenter.post(name: Notification.Name(rawValue: "UserObjectDidUpdate"), object: nil, userInfo: [ "info" : validJson])
                        //let defaults = UserDefaults.standard
                        //var spotifyLoginInfo = [String: String]()
                        //spotifyLoginInfo.updateValue(self.clientID!, forKey: "client_id")
                        //spotifyLoginInfo.updateValue(self.clientSecret!, forKey: "client_secret")
                        //spotifyLoginInfo.updateValue(self.accessToken!, forKey: "access_token")
                        //defaults.set(spotifyLoginInfo, forKey: "spotifyLoginInfo")
                        //print(defaults.dictionaryRepresentation())
                    }
                }
                catch ParseError.access_token{
                    print ("Error in parse error access_token")
                }
                catch {
                    print("Error encountered parsing: \(error)")
                }
            }
            if response != nil {
                print(response)
            }
            }.resume()
    }
    
    func getTracks(complete: @escaping ([AlbumTracks]?)->Void) {
        var validAlbumTracksToReturn: [AlbumTracks] = []
        let url = URL(string:"https://api.spotify.com/v1/me/tracks")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let validAccessToken = self.accessToken else { return }
        request.addValue("Bearer \(validAccessToken)", forHTTPHeaderField: "Authorization")
        print(request.url?.absoluteString)
        dump(request)
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
            }
            guard let validData = data else { return }
            dump(validData)
            guard let validAlbumTracks = AlbumTracks.tracks(fromFavorite: validData) else { return }
            print("The following are the tracks...!?")
            dump(validAlbumTracks)
            print("The above are the tracks...!?")
            validAlbumTracksToReturn = validAlbumTracks
            complete(validAlbumTracksToReturn)
        }.resume()
    }
    
}
