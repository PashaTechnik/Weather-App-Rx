//
//  Weather.swift
//  Weather App Rx
//
//  Created by Pasha on 23.11.2022.
//

import Foundation


// MARK: - Result
struct Result: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
    
    static var placeholder: Self {
        return Result(cod: nil, message: nil, cnt: nil, list: nil, city: nil)
    }
}


// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - List
struct List: Codable, Identifiable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: TimeInterval?
    let sys: Sys?
    let id: Int?
    let name: String?
    let cod: Int?
    
    func getDayFromDate() -> String {
        let date = Date(timeIntervalSince1970: dt!)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date)
    }
    
    func getHoursFromDate() -> String {
        let date = Date(timeIntervalSince1970: dt!)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return String(hour)
    }
    
    func getLocalizedDateFromDate() -> String {
        let date = Date(timeIntervalSince1970: dt!)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EE, d MMMM"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp: Double?
    let pressure, humidity: Int?
    let tempMin, tempMax: Double?

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: TimeInterval?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}
// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}

// MARK: - WeatherModel
struct WeatherModel {
    let date: String
    let minTemperature: Double
    let maxTemperature: Double
    let city: String
    let humidity: String
    let windSpeed: String
    let windDirection: String
    let icon: String
}
