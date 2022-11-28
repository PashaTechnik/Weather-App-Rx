//
//  LocationManager.swift
//  Weather App Rx
//
//  Created by Pasha on 28.11.2022.
//

import Foundation
import CoreLocation
import RxSwift


class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    func getCoordinates() -> Observable<CLLocationCoordinate2D> {
        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return Observable.just(CLLocationCoordinate2D(latitude: 0, longitude: 0)) }
        return Observable.just(locValue)
    }
}
