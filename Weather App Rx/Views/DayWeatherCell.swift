//
//  DayWeatherCell.swift
//  Weather App Rx
//
//  Created by Pasha on 28.11.2022.
//

import UIKit


class DayWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    static let identifier = "dayWeatherCell"
    
    var cellViewModel: DayWeatherCellViewModel? {
        didSet {
            timeLabel.text = cellViewModel?.time
            temperatureLabel.text = cellViewModel?.temperature
            weatherImage.image = cellViewModel?.forecastIcon
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
