//
//  BrowseCollectionViewController.swift
//  SpotifySearch
//
//  Created by Marcel Chaucer on 11/9/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BrowseCollectionViewController: UICollectionViewController {

    var relatedArtists: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRelatedArtists()
               self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    func loadRelatedArtists (){
        APIRequestManager.manager.getData(endPoint: "https://api.spotify.com/v1/artists/5K4W6rqBFWDnAN6FQUkS6x/related-artists") { (data: Data?) in
            if let validData = data {
                guard let validArtist = Artist.getArtists(from: validData) else {return}
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
        return relatedArtists.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! BrowseCollectionViewCell
        let theArtist = relatedArtists[indexPath.row]
        let url = URL(string: theArtist.image)
        let data = try? Data(contentsOf: url!)
        
        
        cell.artistName.text = theArtist.artistName
        cell.artistImage.image = UIImage(data: data!)
        // Configure the cell
    
        return cell
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
