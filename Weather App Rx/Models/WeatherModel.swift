//
//  WeatherModel.swift
//  Weather App
//
//  Created by Pasha on 04.11.2022.
//

import Foundation


struct WeatherModel {
    let date: String
    let minTemperature: Double
    let maxTemperature: Double
    let city: String
    let humidity: String
    let windSpeed: String
    let windDirection: String
    let icon: String
    
    static var placeholder: Self {
        return WeatherModel(date: "", minTemperature: 0, maxTemperature: 0, city: "", humidity: "", windSpeed: "", windDirection: "icon_wind_e", icon: "02d")
    }
}
