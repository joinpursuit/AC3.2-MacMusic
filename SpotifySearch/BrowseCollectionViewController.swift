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
        //loadRelatedArtists()
        let notificationName = Notification.Name(rawValue: "searchDidChange")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (notification) in
            if let userInfo = notification.userInfo as? [String: String] {
                if let id = userInfo["searchTerm"] {
                    self.artistIDs = id
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadRelatedArtists()
        self.collectionView?.reloadData()

    }

//    func searchDidChange(artistID: String) {
//        self.artistIDs = artistID
//        print(artistIDs)
//    }
    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
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
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let selectedArtist = self.relatedArtists[indexPath.row]
        tabBarController?.selectedIndex = 1
        
        DispatchQueue.main.async {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchForArtist") , object: nil, userInfo: ["searchArtist": selectedArtist.artistName])
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
