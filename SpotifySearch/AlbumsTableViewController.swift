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
    
    var artistName = ""
    
    var trackArray: [Track] = []
    
    var iTunesArray: [iTunes] = []
    
    var videosArray: [Video] = []
    
    var trackURL = "http://api.musixmatch.com/ws/1.1/track.search?apikey=a94099f771b956511ae7b523023eea65&q_track=Complicated&q_artist=Avril&page_size=10"
    
    var iTunesURL = "https://itunes.apple.com/search?country=US&media=music&entity=musicTrack&term=adele%20hello"
    
    var videoURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=Adele+Hello&type=video&key=AIzaSyAtF36hcFVY9F8ZetEbSLvXVzeu1RtJzD8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchBar()
        makeSearch()
        
        let notificationArtist = Notification.Name(rawValue: "searchForArtist")
        NotificationCenter.default.addObserver(forName: notificationArtist, object: nil, queue: nil) { (notification) in
                self.makeSearch()            
            }
    

        self.navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 132.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
   
    func makeSearch () {
        APIRequestManager.manager.getAlbumsUsingAPI(artist: self.artistName) { (data: Data?) in
            if let unwrappedReturnedAlbumData = Album.albums(from: data!) {
                self.album = unwrappedReturnedAlbumData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchDidChange") , object: nil, userInfo: ["searchTerm":"\(self.album[0].artistID)"])
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCellID", for: indexPath) as! AlbumTableViewCell
        
        let album = self.album[indexPath.row]
        cell.albumNameLabel.text = album.name
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
