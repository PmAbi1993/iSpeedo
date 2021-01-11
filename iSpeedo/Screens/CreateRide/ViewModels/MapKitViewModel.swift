//
//  MapKitViewModel.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import CoreLocation

protocol MapKitViewModelDelegate {
    func locationAccessDenied()
    func locationUpdated(location: CLLocation)
}

class MapKitViewModel: NSObject {
    
    private var delegate: MapKitViewModelDelegate?
    private lazy var locationManager: CLLocationManager = {
        
        let locationManager: CLLocationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
        
    }()
    init(delegate: MapKitViewModelDelegate) {
        self.delegate = delegate
    }
    func startLocationServices() {
        self.locationManager.requestAlwaysAuthorization()
    }
}

extension MapKitViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            self.delegate?.locationAccessDenied()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else {
            print("The locations array has no elements")
            return }
        self.delegate?.locationUpdated(location: currentLocation)
    }
}
