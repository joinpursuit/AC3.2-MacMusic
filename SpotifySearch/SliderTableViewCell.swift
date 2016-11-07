//
//  SliderTableViewCell.swift
//  SpotifySearch
//
//  Created by Cris on 10/30/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

protocol slideCellDelegate {
    func sliderDidChange(_ value: Int)
}

class SliderTableViewCell: UITableViewCell {
    
    var delegate: slideCellDelegate?

    @IBOutlet weak var numberOfResultsLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    
    @IBAction func didChangeValue(_ sender: UISlider) {
        self.numberOfResultsLabel.text = "\(Int(sender.value))"
        self.delegate?.sliderDidChange(Int(sender.value))
    }
    
    internal func updateSlider(min: Int, max: Int, current: Int) {
        slider.minimumValue = Float(SettingsManager.manager.minResults)
        slider.maximumValue = Float(SettingsManager.manager.maxResults)
        self.slider.setValue(Float(current), animated: true)
        
        numberOfResultsLabel.text = "\(current)"
    }
}
