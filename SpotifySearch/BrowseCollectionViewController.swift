//
//  BrowseCollectionViewController.swift
//  SpotifySearch
//
//  Created by Marcel Chaucer on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class BrowseCollectionViewController: UICollectionViewController {
    
    var relatedArtists: [Artist] = []
    
    var artistIDs: String = "3WGpXCj9YhhfX11TToZcXP"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
        let notificationName = Notification.Name(rawValue: "searchDidChange")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (notification) in
            if let userInfo = notification.userInfo as? [String: String] {
                if let id = userInfo["searchTerm"] {
                    self.artistIDs = id
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      self.loadRelatedArtists()
        
    }
    


    
    func loadRelatedArtists (){
        APIRequestManager.manager.getData(endPoint: "https://api.spotify.com/v1/artists/\(artistIDs)/related-artists") { (data: Data?) in
            if let validData = data,
                let validArtist = Artist.getArtists(from: validData) {
                self.relatedArtists = validArtist
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    
  
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.relatedArtists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! BrowseCollectionViewCell
        let theArtist = relatedArtists[indexPath.row]
        
        cell.artistName.text = theArtist.artistName
        cell.artistImage.downloadImage(urlString: theArtist.image)
        //cell.backgroundColor = UIColor.blue
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        DispatchQueue.main.async {
        let selectedArtist = self.relatedArtists[indexPath.row]
        self.tabBarController?.selectedIndex = 1
        print(selectedArtist.artistName)
        
            if let nc = self.tabBarController?.viewControllers?[1] as? UINavigationController,
                let atvc = nc.viewControllers[0] as? AlbumsTableViewController {
                atvc.artistName = selectedArtist.artistName
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "searchForArtist") , object: nil)
            
        }
        
    }
   
    
}
