//
//  AlbumTracksViewController.swift
//  SpotifySearch
//
//  Created by Cris on 11/7/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

// this is a change - JG
class AlbumTracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AlbumImageView: UIImageView!
    @IBOutlet weak var trackTableView: UITableView!
    
    var albumSelected: Album!
    
    internal var tracks: [AlbumTracks] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTableView.delegate = self
        trackTableView.dataSource = self
        
        self.title = albumSelected.name
        AlbumImageView.downloadImage(urlString: albumSelected.largeImageURL)
        
        getAlbumTracks()
    }
    
    func getAlbumTracks() {
        APIRequestManager.manager.getTracksUsingAPI(trackID: albumSelected.albumID, completion: { (data: Data?) in
            if let unwrappedReturnedAlbumData = AlbumTracks.tracks(from: data!){
                self.tracks = unwrappedReturnedAlbumData
                
                DispatchQueue.main.async {
                    self.trackTableView.reloadData()
                }
            }
        }
        )}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCellID", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(String(track.trackNumber)). \(track.trackName)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToTrack" {
            if let dest = segue.destination as? TrackViewController,
                let indexPath = trackTableView.indexPathForSelectedRow {
                dest.trackSelected = tracks[indexPath.row]
                dest.albumImg = albumSelected.largeImageURL

            }
        }
    }
    
}
