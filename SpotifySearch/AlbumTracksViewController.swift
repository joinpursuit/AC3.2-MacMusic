//
//  AlbumTracksViewController.swift
//  SpotifySearch
//
//  Created by Cris on 11/7/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class AlbumTracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AlbumImageView: UIImageView!
    
    @IBOutlet weak var trackTableView: UITableView!
    
    var albumSelected: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackTableView.delegate = self
        trackTableView.dataSource = self
        
        self.title = albumSelected.name
        AlbumImageView.downloadImage(urlString: albumSelected.largeImageURL)
        
        APIRequestManager.manager.getTracksUsingAPI(trackID: albumSelected.albumID, completion: { (data: Data?) in
            if let unwrappedReturnedAlbumData = Album.albums(from: data!) {
                self.album = unwrappedReturnedAlbumData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        
        
        
        
        
    }
}
