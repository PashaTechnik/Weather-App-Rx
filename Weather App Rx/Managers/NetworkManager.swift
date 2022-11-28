//
//  NetworkManager.swift
//  Weather App Rx
//
//  Created by Pasha on 27.11.2022.
//

import Foundation
import RxSwift

protocol NetworkManagerProtocol {
    func loadForecastWithCoord(lat: Double, lon: Double) -> Observable<Result>
    func loadForecastWithCity(city: String) -> Observable<Result>
}

class NetworkManager: NetworkManagerProtocol {
    
    let disposeBag = DisposeBag()
    
    private let baseaseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let apiKey = "1f7f0d7b3906c31e1158ca98f1fea4c2"
    
    private enum Error: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }
    
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
    
    
    func loadForecastWithCoord(lat: Double, lon: Double) -> Observable<Result> {
        guard let url = absoluteURLCoord(lat: lat, lon: lon) else { return Observable.just(Result.placeholder) }
        return fetchForecast(url: url)
    }
    
    func loadForecastWithCity(city: String) -> Observable<Result> {
        guard let url = absoluteURLCity(city: city) else { return Observable.just(Result.placeholder) }
        return fetchForecast(url: url)
    }
    
    func fetchForecast(url: URL) -> Observable<Result> {
        return URLSession.shared.rx.response(request: URLRequest(url: url))
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw Error.invalidResponse(result.response)
                }
                return result.data
            }.map { data in
                do {
                    let result = try JSONDecoder().decode(
                        Result.self, from: data
                    )
                    return result
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .observe(on: MainScheduler.instance)
            .asObservable()
   }
    
}
