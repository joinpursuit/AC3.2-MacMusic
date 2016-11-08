//
//  AlbumsTableViewController.swift
//  SpotifySearch
//
//  Created by Cris on 10/28/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    internal var album: [Album] = []
    
    var trackArray: [Track] = []
    var track = "http://api.musixmatch.com/ws/1.1/track.search?apikey=a94099f771b956511ae7b523023eea65&q_track=Complicated&q_artist=Avril&page_size=10"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        createSearchBar()
        self.navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 132.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    func loadData() {
        APIRequestManager.manager.getAlbumsUsingAPI() { (data: Data?) in
            if let unwrappedReturnedAlbumData = Album.albums(from: data!) {
                self.album = unwrappedReturnedAlbumData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        APIRequestManager.manager.getData(endPoint: track) { (data: Data?) in
            if let validData = data {
                guard let validTrack = Track.getTrack(from: validData) else {return}
                self.trackArray = validTrack
                dump(self.trackArray)
                //dump(validTrack)
            }
        }
        
    }
    
    func createSearchBar() {
        let searchbar = UISearchBar()
        searchbar.showsCancelButton = false
        searchbar.placeholder = "Enter artist to search"
        searchbar.delegate = self
        self.navigationItem.titleView = searchbar
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        APIRequestManager.manager.getAlbumsUsingAPI(artist: searchTerm) { (data: Data?) in
            if let unwrappedReturnedAlbumData = Album.albums(from: data!) {
                self.album = unwrappedReturnedAlbumData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        return album.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCellID", for: indexPath) as! AlbumTableViewCell
        
        let album = self.album[indexPath.row]
        cell.albumNameLabel.text = "\(indexPath.row + 1) : \(album.name)"
        cell.albumImageView.downloadImage(urlString: album.smallImageURL!)
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueFromAlbumToTracks" {
            if let dest = segue.destination as? AlbumTracksViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                dest.albumSelected = album[indexPath.row]
            }
        }
        
    }
    
    
}
