//
//  FavoritesTableViewController.swift
//  SpotifySearch
//
//  Created by Cris on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class Favorites {
    let songName: String
    let songID: String
    let songLyricsID: String
    let artistName: String
    
    init(songName: String, songID: String, songLyricsID: String, artistName: String) {
        self.songName = songName
        self.songID = songID
        self.songLyricsID = songLyricsID
        self.artistName = artistName
    }
    
}

class FavoritesTableViewController: UITableViewController {
    
    var favoritesArray = [Favorites]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let favoriteSongsDict = UserDefaults.standard.value(forKey: "favoriteSongs") as? [[String : String]] {
            print(favoriteSongsDict)
            for dict in favoriteSongsDict {
//                guard dict.keys.count > 1 else {return}
            if let songName = dict["track_name"],
                    let songID = dict["track_id"],
                    let songLyricsID = dict["track_lyrics_id"],
                    let artistName = dict[ "artist_name"] {
                    
                    let favoriteSongs = Favorites(songName: songName, songID: songID, songLyricsID: songLyricsID, artistName: artistName)
                    favoritesArray.append(favoriteSongs)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
            
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoritesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteSongCellID", for: indexPath) as! FavoritesTableViewCell
        let faveSong = favoritesArray[indexPath.row]
        cell.favoriteTrackLabel.text = faveSong.songName
        print(favoritesArray)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
