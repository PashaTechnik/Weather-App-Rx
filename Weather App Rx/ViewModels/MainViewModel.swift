//
//  MainViewModel.swift
//  Weather App Rx
//
//  Created by Pasha on 25.11.2022.
//

import Foundation
import RxSwift
import RxCocoa


class WeatherViewModel: NSObject {
    private let networkManager: NetworkManagerProtocol
    
    private let locationManager = LocationManager()
    
    var weatherCellViewModels = PublishSubject<[WeatherCellViewModel]>()
    
    var dayWeatherCellViewModels = PublishSubject<[DayWeatherCellViewModel]>()
    
    private let bag = DisposeBag()
    
    var weatherModel: BehaviorRelay<WeatherModel>!
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    
//    func fetchData(result: Result) {
//        self.forecastResult = result
//        initWeatherCell()
//        initDayWeatherCell()
//        initWeatherModel()
//    }
    
//    func initWeatherCell() {
//        var weatherCellViewModel = [WeatherCellViewModel]()
//
//
//        let forecasts = forecastResult.list.groupedBy(dateComponents: [.day, .month, .year]).sorted( by: { $0.0 < $1.0 })
//
//        for forecast in forecasts {
//            let day = forecast.value.first!.getDayFromDate()
//            let min = forecast.value.map { $0.main.tempMin }.min() ?? 0
//            let max = forecast.value.map { $0.main.tempMax }.max() ?? 0
//            let icon = forecast.value.map({ $0.weather.first!.icon }).filter({ !$0.contains("n") }).mostFrequent() ?? "02d"
//
//            weatherCellViewModel.append(WeatherCellViewModel(forecast: WeatherCellModel(day: day, minTemperature: min, maxTemperature: max, icon: icon)))
//        }
//        weatherCellViewModels = weatherCellViewModel
//    }
    
    func initDayWeatherCell() {
        networkManager.loadForecastWithCity(city: "")
            .flatMap { result -> Observable<[DayWeatherCellViewModel]> in
                self.getDayWeatherCellViewModel(result: result)
            }
            .bind(to: dayWeatherCellViewModels).disposed(by: bag)
    }
    
    private func getDayWeatherCellViewModel(result: Result) -> Observable<[DayWeatherCellViewModel]> {
        var dayWeatherCellViewModel = [DayWeatherCellViewModel]()
        let forecasts = result.list!.prefix(10)
        
        for forecast in forecasts {
            let time = forecast.getHoursFromDate()
            let temperature = (forecast.main?.temp)!
            let icon = forecast.weather?.first!.icon
            
            dayWeatherCellViewModel.append(DayWeatherCellViewModel(forecast: DayWeatherCellModel(time: time, temperature: temperature, icon: icon!)))
        }
        return Observable.just(dayWeatherCellViewModel)
    }
    
//    func initWeatherModel() {
//        guard let forecast = forecastResult.list.first
//        else {
//            weatherModel.value = nil
//            return
//        }
//
//        let date = forecast.getLocalizedDateFromDate()
//        let icon = forecast.weather.first!.icon
//        let minTemperature = forecast.main.tempMin
//        let maxTemperature = forecast.main.tempMax
//        let city = forecastResult.city.name
//        let humidity = String(forecast.main.humidity) + "%"
//        let windSpeed = String(Int(forecast.wind.speed)) + "м/с"
//        let windDirection = "icon_wind_" + Utilities.getwindDirection(deg: forecast.wind.deg)
//        let weather = WeatherModel(date: date, minTemperature: minTemperature, maxTemperature: maxTemperature, city: city, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection, icon: icon)
//
//        weatherModel.value = weather
//    }
//
//    func getCellViewModel(at indexPath: IndexPath) -> WeatherCellViewModel {
//        return weatherCellViewModels[indexPath.row]
//    }
//
//    func getDayWeatherCellViewModel(at indexPath: IndexPath) -> DayWeatherCellViewModel {
//        return dayWeatherCellViewModels[indexPath.row]
//    }

}
