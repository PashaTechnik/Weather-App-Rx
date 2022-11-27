//
//  WeatherCellViewModel.swift
//  Weather App Rx
//
//  Created by Pasha on 27.11.2022.
//

import UIKit

class WeatherCellViewModel {
    
    private var forecast: WeatherCellModel
    
    var day: String {
        return forecast.day
    }
    
    var temperature: String {
        return "\(forecast.minTemperature)° / \(forecast.maxTemperature)°"
    }
    
    var forecastIcon: UIImage {
        return UIImage(named: Utilities.iconDict[forecast.icon, default: "ic_white_day_bright"]) ?? UIImage()
    }
    
    
    init(forecast: WeatherCellModel) {
        self.forecast = forecast
    }
}
