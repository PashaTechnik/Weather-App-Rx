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

    
    func initPlacesResult() {
        let token = GMSAutocompleteSessionToken.init()
        
        let filter = GMSAutocompleteFilter()
        
        filter.types = ["locality"]
        placesClient.findAutocompletePredictions(fromQuery: cityName.value, filter: filter,
            sessionToken: token,
            callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            if let results = results {
                self.placesResult.onNext(results)
                self.placesResult.onCompleted()
            }
        })
    }
}
