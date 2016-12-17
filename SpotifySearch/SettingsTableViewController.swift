//
//  SettingsTableViewController.swift
//  SpotifySearch
//
//  Created by Cris on 10/30/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath)
            if let sliderCell: SliderTableViewCell = cell as? SliderTableViewCell {
                sliderCell.delegate = SettingsManager.manager
                sliderCell.updateSlider(min: SettingsManager.manager.minResults,
                                        max: SettingsManager.manager.maxResults,
                                        current: SettingsManager.manager.limit)
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
            if let segmentedCell: SegmentedControlTableViewCell = cell as? SegmentedControlTableViewCell {
                segmentedCell.delegate = SettingsManager.manager
                segmentedCell.setMusicTypes(to: SettingsManager.manager.type)
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "chooseMarket", for: indexPath)
        }
        return cell
    }
}
