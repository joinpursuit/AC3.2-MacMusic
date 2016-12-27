//
//  TrackViewController.swift
//  SpotifySearch
//
//  Created by Cris on 11/8/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit
import AVFoundation

class TrackViewController: UIViewController {
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var atistNameLabel: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var iTunesButton: UIButton!
    @IBOutlet weak var youTubeButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    
    var favoriteStatus : FavoriteManager {
        get{
            return FavoriteManager(track: self.trackSelected, isAlreadyAdded: false)
        }
        set (newValue) {
            self.favoriteStatus = newValue
        }
    }
    
    //var favButtonPressedCount = 0
    
    var trackSelected: AlbumTracks!
    var albumImg: String!
    
    var trackPlaying: AVAudioPlayer!
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    var trackArray: [Track] = []
    var trackID = Int()
    var lyricArray: [Lyrics] = []
    var iTunesArray: [iTunes] = []
    var videosArray: [Video] = []
    
    var trackBaseURL = "http://api.musixmatch.com/ws/1.1/track.search?apikey=a94099f771b956511ae7b523023eea65"
    var trackURL = ""
    
    var lyricsBaseURL = "http://api.musixmatch.com/ws/1.1/track.lyrics.get?apikey=c4c49544dec7305a9c6a01af96bfdcb3&track_id="
    var lyricsURL = ""
    
    var iTunesBaseURL = "https://itunes.apple.com/search?country=US&media=music&entity=musicTrack"
    var iTunesURL = ""
    
    var iTunesDemoBaseURL = "https://itunes.apple.com/us/album/25/id1051394208#"
    var iTunesDemoURL = ""
    
    var videoBaseURL = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyAtF36hcFVY9F8ZetEbSLvXVzeu1RtJzD8&order=viewCount&part=snippet&type=video"
    var videoURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackImageView.downloadImage(urlString: albumImg)
        self.title = trackSelected.trackName
        trackNameLabel?.text = trackSelected.trackName
        atistNameLabel.text = trackSelected.singerName
        
        playAudio()
        loadTrackId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.favoriteStatus.updateButtonStatus(self.favoritesButton)
//            let userDefaults = UserDefaults.standard
//            if let favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
//                for song in favoriteSongs {
//                    if song["track_id"] == self.trackSelected.trackID {
//                        self.favButtonPressedCount = 1
//                    }
//                }
//            }
//            
//            if self.favButtonPressedCount == 0 {
//                self.favoritesButton.setBackgroundImage(UIImage(named: "plus-circle-outline"), for: UIControlState.normal)
//            } else {
//                self.favoritesButton.setBackgroundImage(UIImage(named: "minus-5-512"), for: UIControlState.normal)
//            }
        }
    }
    
    func playAudio() {
        guard let trackPrev = URL(string: trackSelected.trackPreviewURL) else {return}
        playerItem = AVPlayerItem(url: trackPrev)
        player = AVPlayer(playerItem: playerItem!)
        let playerLayer=AVPlayerLayer(player: player!)
        self.view.layer.addSublayer(playerLayer)
    }
    
    //www.swiftdeveloperblog.com/play-music-mp3-file-example-in-swift/
    //Above link is a tutorial for playing an mp3 file --
    @IBOutlet weak var playPauseButtonOutlet: UIButton!
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if player?.rate == 0
        {
            player!.play()
            playPauseButtonOutlet.setBackgroundImage(UIImage(named: "pause_button"), for: UIControlState.normal)
            playPauseButtonOutlet.alpha = 0.50
            
        } else {
            player!.pause()
            playPauseButtonOutlet.setBackgroundImage(UIImage(named: "play_button"), for: UIControlState.normal)
            playPauseButtonOutlet.alpha = 0.50
        }
    }
    
    func loadTrackId(){
        guard let searchTrackName: String = trackSelected.trackName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let searchTrackSinger: String = trackSelected.singerName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        trackURL = trackBaseURL + "&q_track=" + searchTrackName + "&q_artist=" + searchTrackSinger + "&page_size=10"
        
        APIRequestManager.manager.getData(endPoint: trackURL) { (data: Data?) in
            if let validData = data {
                guard let validTrack = Track.getTrack(from: validData) else {return}
                self.trackArray = validTrack
                DispatchQueue.main.async {
                    guard self.trackArray.count > 0 else {return}
                    self.trackID = self.trackArray[0].track_id
                    APIRequestManager.manager.getData(endPoint: self.lyricsBaseURL + String(self.trackID), callback: { (data: Data?) in
                        if let validLyricData = data {
                            guard let validLyrics = Lyrics.getInfo(from: validLyricData) else {return}
                            self.lyricArray = validLyrics
                            DispatchQueue.main.async {
                                guard self.lyricArray.count > 0 else {return}
                                self.lyricsTextView.text = self.lyricArray[0].lyricsBody
                            }
                        }
                    })
                }
            }
        }
    }
    
    func addToFavorites() {
        self.favoriteStatus.addToFavorites()
//        let userDefaults = UserDefaults.standard
//        
//        var favoriteSong = [String: String]()
//        favoriteSong.updateValue(trackSelected.trackID, forKey: "track_id")
//        favoriteSong.updateValue(trackSelected.trackName, forKey: "track_name")
//        favoriteSong.updateValue(trackSelected.singerName, forKey: "artist_name")
//        favoriteSong.updateValue(String(trackID), forKey: "track_lyrics_id")
//        favoriteSong.updateValue(String(trackSelected.trackNumber), forKey: "track_number")
//        favoriteSong.updateValue(trackSelected.trackPreviewURL, forKey: "track_preview_URL")
//        favoriteSong.updateValue(albumImg, forKey: "album_Img")
//        
//        if var favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
//            favoriteSongs.append(favoriteSong)
//            userDefaults.set(favoriteSongs, forKey: "favoriteSongs")
//        } else {
//            userDefaults.set([favoriteSong], forKey: "favoriteSongs")
//        }
//        favButtonPressedCount = 1
    }
    
    func removeFromFavorites() {
        self.favoriteStatus.removeFromFavorites()
//        let userDefaults = UserDefaults.standard
//        
//        if var favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
//            for (index,song) in favoriteSongs.enumerated() {
//                if song["track_id"] == trackSelected.trackID {
//                    favoriteSongs.remove(at: index)
//                    userDefaults.set(favoriteSongs, forKey: "favoriteSongs")
//                    favButtonPressedCount = 0
//                }
//            }
//        }
    }
    
    @IBAction func favoriteSongPressed(_ sender: UIButton) {
        self.favoriteStatus.favoriteSongPressed(sender)
//        let userDefaults = UserDefaults.standard
//        
//        if let favoriteSongs = userDefaults.object(forKey: "favoriteSongs") as? [[String: String]]  {
//            for song in favoriteSongs {
//                if song["track_id"] == trackSelected.trackID {
//                    favButtonPressedCount = 1
//                }
//            }
//        }
//        
//        if favButtonPressedCount == 0 {
//            addToFavorites()
//            favoritesButton.setBackgroundImage(UIImage(named: "minus-5-512"), for: UIControlState.normal)
//        } else {
//            removeFromFavorites()
//            favoritesButton.setBackgroundImage(UIImage(named: "plus-circle-outline"), for: UIControlState.normal)
//        }
//        
    }
    
    @IBAction func iTunesButtonPressed(_ sender: UIButton) {
        guard let searchiTunesName: String = trackSelected.trackName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let searchiTunesSinger: String = trackSelected.singerName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        iTunesURL = iTunesBaseURL + "&term=" + searchiTunesName + "%20" + searchiTunesSinger
        //print("To get iTunes Object" + iTunesURL + " Ends Here")
        
        //http://stackoverflow.com/questions/433907/how-to-link-to-apps-on-the-app-store
        APIRequestManager.manager.getData(endPoint: iTunesURL) { (data: Data?) in
            guard let validData = data else {return}
            guard let validiTunes = iTunes.getiTunes(from: validData) else {return}
            self.iTunesArray = validiTunes
            DispatchQueue.main.async {
                if self.iTunesArray.count > 0 {
                    let iTunesTrackURL = self.iTunesArray[0].trackViewUrl //works with openingMusic
                    guard let url = URL(string: iTunesTrackURL) else {return}
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func youTubeButtonPressed(_ sender: UIButton) {
        let searchString = trackSelected.singerName + " " + trackSelected.trackName
        let searchStringWithPlus = searchString.replacingOccurrences(of: " ", with: "+")
        videoURL = videoBaseURL + "&q=" + searchStringWithPlus
        //print(videoURL)
        APIRequestManager.manager.getData(endPoint: videoURL) { (data: Data?) in
            if let validData = data{
                guard let validVideos = Video.getVideo(from: validData) else {return}
                self.videosArray = validVideos
                DispatchQueue.main.async {
                    if self.videosArray.count > 0 {
                        let youtubeURL = "https://www.youtube.com/watch?v=" + self.videosArray[0].videoId
                        guard let url = URL(string: youtubeURL) else {return}
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        //https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=nicki+minaj+anaconda&type=video&key=AIzaSyAtF36hcFVY9F8ZetEbSLvXVzeu1RtJzD8
        //https://www.youtube.com/watch?v=LDZX4ooRsWs
    }
    
    
    @IBAction func socialButtonPressed(_ sender: UIButton) {
        
    }
    
    
}
