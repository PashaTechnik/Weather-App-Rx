//
//  NetworkManager.swift
//  Weather App Rx
//
//  Created by Pasha on 27.11.2022.
//

import Foundation
import RxSwift

protocol NetworkManagerProtocol {
    func loadForecastWithCoord(lat: Double, lon: Double, completion: @escaping (WeatherDetail) -> Void)
    func loadForecastWithCity(city: String, completion: @escaping (WeatherDetail) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    let disposeBag = DisposeBag()
    private enum Error: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }
    func loadForecastWithCoord(lat: Double, lon: Double) -> Observable<[WeatherDetail]> {

        guard let request = absoluteURLCoord(lat: lat, lon: lon) else { return Observable.just([]) }
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw Error.invalidResponse(result.response)
                }
                return result.data
            }.map { data in
                do {
                    let posts = try JSONDecoder().decode(
                        [Post].self, from: data
                    )
                    return posts
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .observeOn(MainScheduler.instance)
            .asObservable()
   }
    
    private let baseaseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let apiKey = "1f7f0d7b3906c31e1158ca98f1fea4c2"
    
    private func absoluteURLCoord(lat: Double, lon: Double) -> URL? {
        let queryURL = URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "lat", value: String(lat)),
                                    URLQueryItem(name: "lon", value: String(lon)),
                                    URLQueryItem(name: "units", value: "metric")]
        return urlComponents.url
    }
    
    private func absoluteURLCity(city: String) -> URL? {
        let queryURL = URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        //let city = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "units", value: "metric")]
        return urlComponents.url
    }

    func loadForecastWithCoord(lat: Double, lon: Double, completion: @escaping (WeatherDetail) -> Void) {

        if let url = absoluteURLCoord(lat: lat, lon: lon) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    let decoder = JSONDecoder()

                    guard let result = try? decoder.decode(WeatherDetail.self, from: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
            urlSession.resume()
        }
    }
    
    func loadForecastWithCity(city: String, completion: @escaping (WeatherDetail) -> Void) {

        if let url = absoluteURLCity(city: city) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    let decoder = JSONDecoder()

                    guard let result = try? decoder.decode(WeatherDetail.self, from: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(result)
                    }

                }
            }
            urlSession.resume()
        }
    }
}
