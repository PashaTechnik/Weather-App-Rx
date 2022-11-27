//
//  SearchViewModel.swift
//  Weather App Rx
//
//  Created by Pasha on 25.11.2022.
//

import Foundation
import RxSwift
import RxCocoa
import GooglePlaces


class SearchViewModel {
    let placesResult = PublishSubject<[GMSAutocompletePrediction]>()
    
    private let placesClient = GMSPlacesClient()
    
    var cityName = BehaviorRelay<String>(value: "")
    private let bag = DisposeBag()
    
    init() {
        cityName
            .debounce(.milliseconds(300), scheduler:  MainScheduler.instance)
            .flatMap { String -> Observable<[GMSAutocompletePrediction]> in
                self.initPlacesResult(city: String)
            }
            .bind(to: placesResult)
            .disposed(by: bag)
        
    }
    
    
    func initPlacesResult(city: String) -> Observable<[GMSAutocompletePrediction]> {
        let token = GMSAutocompleteSessionToken.init()
        
        let filter = GMSAutocompleteFilter()
        
        filter.types = ["locality"]
        
        let observable = Observable<[GMSAutocompletePrediction]>.create { [self] observer -> Disposable in
            placesClient.findAutocompletePredictions(fromQuery: city, filter: filter, sessionToken: token,
                                                     callback: { (results, error) in
                                                        if let error = error {
                                                            print("Autocomplete error: \(error)")
                                                            return
                                                        }
                                                        if let results = results {
                                                            print(results)
                                                            observer.onNext(results)
                                                            observer.onCompleted()
                                                        }
                                                     })
            return Disposables.create()
        }
        return observable
    }
    
    
}
