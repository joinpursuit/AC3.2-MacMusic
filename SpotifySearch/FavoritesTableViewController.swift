//
//  FavoritesTableViewController.swift
//  SpotifySearch
//
//  Created by Cris on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit


class FavoritesTableViewController: UITableViewController {
    
    var favoritesArray = [AlbumTracks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let favoriteSongsDict = UserDefaults.standard.value(forKey: "favoriteSongs") as? [[String : String]] {
            favoritesArray.removeAll()
            for dict in favoriteSongsDict {
                if let songID = dict["track_id"],
                    let songName = dict["track_name"],
                    let artistName = dict[ "artist_name"],
                    let trackNumber = dict["track_number"],
                    let trackPreviewURL = dict["track_preview_URL"],
                    let lyricsID = dict["track_lyrics_id"],
                    let trackImg = dict["album_Img"]{
                    
                    guard let trackNum = Int(trackNumber) else {return}
                    
                    let favoriteSongs = AlbumTracks(singerName: artistName, trackName: songName, trackID: songID, trackNumber: trackNum, trackPreviewURL: trackPreviewURL, trackLyrics: lyricsID, albumImg: trackImg)
                    favoritesArray.append(favoriteSongs)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteSongCellID", for: indexPath) as! FavoritesTableViewCell
        let faveSong = favoritesArray[indexPath.row]
        cell.favoriteTrackLabel.text = faveSong.trackName
        cell.favoritesTrackImageView.downloadImage(urlString: faveSong.albumImg)
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFromFavoriteToTrack" {
            if let dest = segue.destination as? TrackViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                dest.trackSelected = favoritesArray[indexPath.row]
                dest.albumImg = favoritesArray[indexPath.row].albumImg
            }
        }
    }
    
    
}
