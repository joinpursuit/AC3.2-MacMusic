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
    
    var trackSelected: AlbumTracks!
    var albumImg: String!
    
    var trackPlaying: AVAudioPlayer!
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackImageView.downloadImage(urlString: albumImg)
        self.title = trackSelected.trackName
        trackNameLabel?.text = trackSelected.trackName
        atistNameLabel.text = trackSelected.singerName
        
        playAudio()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio() {
        
        guard let trackPrev = URL(string: trackSelected.trackPreviewURL) else {return}
        print(trackPrev)
        playerItem = AVPlayerItem(url: trackPrev)
        player = AVPlayer(playerItem: playerItem!)
        let playerLayer=AVPlayerLayer(player: player!)
        self.view.layer.addSublayer(playerLayer)
    }
    
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
    
    
}
