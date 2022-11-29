//
//  MainViewModel.swift
//  Weather App Rx
//
//  Created by Pasha on 25.11.2022.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


class WeatherViewModel: NSObject {
    private let networkManager: NetworkManagerProtocol
    
    private let locationManager = LocationManager()
    
    var weatherCellViewModels = PublishSubject<[WeatherCellViewModel]>()
    
    var result = PublishSubject<Result>()
    
    var dayWeatherCellViewModels = PublishSubject<[DayWeatherCellViewModel]>()
    
    private let bag = DisposeBag()
    
    var weatherModel = BehaviorRelay<WeatherModel>(value: WeatherModel.placeholder)
    
    var cityName = PublishSubject<String>()
    var coordinates = PublishSubject<CLLocationCoordinate2D>()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    func initData() {
        coordinates.onNext(locationManager.getCoordinates())
        

        cityName
            .flatMap { [self] city -> Observable<Result> in
            networkManager.loadForecastWithCity(city: city)
            }.share()
            .bind(to: result)
            .disposed(by: bag)
        
        coordinates
            .flatMap { [self] coord -> Observable<Result> in
            networkManager.loadForecastWithCoord(lat: coord.latitude, lon: coord.longitude)
            }.share()
            .bind(to: result)
            .disposed(by: bag)

            
        result
            .flatMap { result -> Observable<[DayWeatherCellViewModel]> in
                self.getDayWeatherCellViewModel(result: result)
            }
            .bind(to: dayWeatherCellViewModels)
            .disposed(by: bag)
        
        result
            .flatMap { result -> Observable<[WeatherCellViewModel]> in
                self.getWeatherCellViewModel(result: result)
            }
            .bind(to: weatherCellViewModels)
            .disposed(by: bag)
        
        result
            .flatMap { result -> Observable<WeatherModel> in
                self.getWeatherModel(result: result)
            }
            .bind(to: weatherModel)
            .disposed(by: bag)
        
        
    }
    
    private func getDayWeatherCellViewModel(result: Result) -> Observable<[DayWeatherCellViewModel]> {
        var dayWeatherCellViewModel = [DayWeatherCellViewModel]()
        let forecasts = result.list!.prefix(10)
        
        for forecast in forecasts {
            let time = forecast.getHoursFromDate()
            let temperature = forecast.main.temp
            let icon = forecast.weather.first!.icon
            
            dayWeatherCellViewModel.append(DayWeatherCellViewModel(forecast: DayWeatherCellModel(time: time, temperature: temperature, icon: icon)))
        }
        return Observable.just(dayWeatherCellViewModel)
    }
    
    private func getWeatherCellViewModel(result: Result) -> Observable<[WeatherCellViewModel]> {
        var weatherCellViewModel = [WeatherCellViewModel]()
        
        
        let forecasts = result.list!.groupedBy(dateComponents: [.day, .month, .year]).sorted( by: { $0.0 < $1.0 })
        
        for forecast in forecasts {
            let day = forecast.value.first!.getDayFromDate()
            let min = forecast.value.map { $0.main.tempMin }.min() ?? 0
            let max = forecast.value.map { $0.main.tempMax }.max() ?? 0
            let icon = forecast.value.map({ $0.weather.first!.icon }).filter({ !$0.contains("n") }).mostFrequent() ?? "02d"
            
            weatherCellViewModel.append(WeatherCellViewModel(forecast: WeatherCellModel(day: day, minTemperature: min, maxTemperature: max, icon: icon)))
        }
        return Observable.just(weatherCellViewModel)
    }
    
    
    private func getWeatherModel(result: Result) -> Observable<WeatherModel> {
        let forecast = result.list!.first!
        let date = forecast.getLocalizedDateFromDate()
        let icon = forecast.weather.first!.icon
        let minTemperature = forecast.main.tempMin
        let maxTemperature = forecast.main.tempMax
        let city = result.city!.name
        let humidity = String(forecast.main.humidity) + "%"
        let windSpeed = String(Int(forecast.wind.speed)) + "м/с"
        let windDirection = "icon_wind_" + Utilities.getwindDirection(deg: forecast.wind.deg)
        let weather = WeatherModel(date: date, minTemperature: minTemperature, maxTemperature: maxTemperature, city: city, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection, icon: icon)

        return Observable.just(weather)
    }

}
