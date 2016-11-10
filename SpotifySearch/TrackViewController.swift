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
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var atistNameLabel: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var iTunesButton: UIButton!
    @IBOutlet weak var youTubeButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    
    var trackSelected: AlbumTracks!
    var albumImg: String!
    
    var trackPlaying: AVAudioPlayer!
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    var trackArray: [Track] = []
    var trackID = Int()
    var lyricArray: [Lyrics] = []
    var iTunesArray: [iTunes] = []
    
    var trackBaseURL = "http://api.musixmatch.com/ws/1.1/track.search?apikey=a94099f771b956511ae7b523023eea65"
    var trackURL = ""
    
   
    var lyricsBaseURL = "http://api.musixmatch.com/ws/1.1/track.lyrics.get?apikey=c4c49544dec7305a9c6a01af96bfdcb3&track_id="
    var lyricsURL = ""
    
    var iTunesBaseURL = "https://itunes.apple.com/search?country=US&media=music&entity=musicTrack"
    var iTunesURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackImageView.downloadImage(urlString: albumImg)
        self.title = trackSelected.trackName
        trackNameLabel?.text = trackSelected.trackName
        atistNameLabel.text = trackSelected.singerName
        
        playAudio()
        
        loadTrackId()
    }
    
  
    
    func playAudio() {
        
        guard let trackPrev = URL(string: trackSelected.trackPreviewURL) else {return}
        print(trackPrev)
        playerItem = AVPlayerItem(url: trackPrev)
        player = AVPlayer(playerItem: playerItem!)
        let playerLayer=AVPlayerLayer(player: player!)
        self.view.layer.addSublayer(playerLayer)
    }
    
    
    
    // www.swiftdeveloperblog.com/play-music-mp3-file-example-in-swift/
    //Above link is a tutorial for playing an mp3 file
    @IBOutlet weak var playPauseButtonOutlet: UIButton!
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if player?.rate == 0
        {
            player!.play()
            playPauseButtonOutlet.setBackgroundImage(UIImage(named: "play_button"), for: UIControlState.normal)
            playPauseButtonOutlet.alpha = 0.50
            
        } else {
            player!.pause()
            playPauseButtonOutlet.setBackgroundImage(UIImage(named: "pause_button"), for: UIControlState.normal)
            playPauseButtonOutlet.alpha = 0.50

        }
    }
    
    func loadTrackId(){
        guard let searchTrackName: String = trackSelected.trackName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let searchTrackSinger: String = trackSelected.singerName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        trackURL = trackBaseURL + "&q_track=" + searchTrackName + "&q_artist=" + searchTrackSinger + "&page_size=10"
        print(trackURL)

        APIRequestManager.manager.getData(endPoint: trackURL) { (data: Data?) in
            if let validData = data {
                guard let validTrack = Track.getTrack(from: validData) else {return}
                self.trackArray = validTrack
                dump(self.trackArray)
                //dump(validTrack)
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
        let defaults = UserDefaults.standard
        
        var favoriteSongs = [[String:String]]()
        var favoriteSong = [String: String]()
        
        favoriteSong.updateValue(trackSelected.trackID, forKey: "track_id")
        favoriteSong.updateValue(trackSelected.trackName, forKey: "track_name")
        favoriteSong.updateValue(trackSelected.singerName, forKey: "artist_name")
        favoriteSong.updateValue(String(trackID), forKey: "track_lyrics_id")
        favoriteSongs.append(favoriteSong)
        
        defaults.set(favoriteSongs, forKey: "favoriteSongs")
        print(favoriteSongs)
    }
    
    
    @IBAction func favoriteSongPressed(_ sender: UIButton) {
        addToFavorites()
    }
    
    @IBAction func iTunesButtonPressed(_ sender: UIButton) {
        guard let searchiTunesName: String = trackSelected.trackName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let searchiTunesSinger: String = trackSelected.singerName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        iTunesURL = iTunesBaseURL + "&term=" + searchiTunesName + "%20" + searchiTunesSinger
        print("To get iTunes Object" + iTunesURL + " Ends Here")

        APIRequestManager.manager.getData(endPoint: iTunesURL) { (data: Data?) in
            guard let validData = data else {return}
            guard let validiTunes = iTunes.getiTunes(from: validData) else {return}
            self.iTunesArray = validiTunes
            DispatchQueue.main.async {
                if self.iTunesArray.count > 0 {
                let iTunesTrackURL = self.iTunesArray[0].trackViewUrl
                    print("To get iTunes Link URL" + iTunesTrackURL + " Ends Here")
                    guard let url = URL(string: iTunesTrackURL) else {return}
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
//        guard let linkedIn = linkedInAccount else {return}
//        let linkedInURLString = "https://www.linkedin.com/in/\(linkedIn)"
//        guard let url = URL(string: linkedInURLString) else {return}
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        
    }
    
    @IBAction func youTubeButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func socialButtonPressed(_ sender: UIButton) {
    }
    
    
}
