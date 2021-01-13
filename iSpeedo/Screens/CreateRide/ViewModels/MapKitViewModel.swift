//
//  MapKitViewModel.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import CoreLocation
import MapKit

protocol MapKitViewModelDelegate {
    func locationAccessDenied()
    func locationUpdated(location: CLLocation)
    func rideDataUpdated(data: [RideData])
}

class MapKitViewModel: NSObject {
    
    
    private var dataModel: [RideData] = [ .averageSpeed(speed: 0),
                                          .distanceCovered(distance: 0),
                                          .liveSpeed(speed: 0),
                                          .rideTime(time: Date())]
    private var delegate: MapKitViewModelDelegate?
    private lazy var locationManager: CLLocationManager = {
        
        let locationManager: CLLocationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
        
    }()
    
    var startTime: Date?
    var previousLocation: CLLocation?
    var distance: Double = 0
    var speedArray: [Double] = []
    var mapView: MKMapView?
    init(delegate: MapKitViewModelDelegate, mapView: MKMapView) {
        self.delegate = delegate
        self.mapView = mapView
    }
    func startLocationServices() {
        self.locationManager.requestAlwaysAuthorization()
    }
    func startMonitoringLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopMonitoringLocation() {
        locationManager.stopUpdatingLocation()
    }
    func clearCurrentRide() {
        startTime = nil
        previousLocation = nil
        distance = 0
        speedArray = []
        self.mapView?.overlays.forEach({ [weak self] (overlay) in
            self?.mapView?.removeOverlay(overlay)
        })
//        [self.mapView removeOverlays:self.mapView.overlays]
    }
    
    func saveRideToDb() {
        
        CoreDataBase.default.addNewRide(rideData: self.dataModel, startDate: self.startTime)
        
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
        drawInMap(sourceLocation: previousLocation ?? currentLocation, destination: currentLocation)

        
        //Update Time Travelled
        self.startTime = self.startTime ?? Date()
        updateModelData(with: .rideTime(time: self.startTime ?? Date()))

        //Update Total Distance Travelled
        if let previousLocation = self.previousLocation {
            self.distance += (currentLocation.distance(from: previousLocation) / 1000)
            self.previousLocation = currentLocation
        } else {
            previousLocation = locations.last
        }
        
        //Update Average Speed
        let currentSpeed: Double = currentLocation.speed * 3.6
        self.speedArray.append(currentSpeed)
        
        let averageSpeed = (self.speedArray.reduce(0.0, +)) / Double(speedArray.count)
        print(averageSpeed)
        updateModelData(with: .averageSpeed(speed: averageSpeed))
        //Update LiveSpeed from the data
        updateModelData(with: .liveSpeed(speed: currentSpeed))
        updateModelData(with: .distanceCovered(distance: self.distance))
        
    }
    func updateModelData(with newData: RideData) {
        for (index, currentData) in self.dataModel.enumerated() {
            if currentData ~= newData {
                dataModel[index] = newData
            }
        }
        self.delegate?.rideDataUpdated(data: self.dataModel)
    }
}



extension MapKitViewModel {
    func drawInMap(sourceLocation: CLLocation, destination: CLLocation) {
        
        guard let mapView = mapView else {
            print("No Map object exists. Exiting Drawing line")
            return }
        
        let directionRequest = MKDirections.Request()
        
        let sourcePosition = CLLocationCoordinate2D(latitude: sourceLocation.coordinate.latitude,
                                           longitude: sourceLocation.coordinate.longitude)
        let destinationPosition = CLLocationCoordinate2D(latitude: destination.coordinate.latitude,
                                                         longitude: destination.coordinate.longitude)
        
        
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourcePosition))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationPosition))
        directionRequest.transportType = .any
        
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            guard let response = response else {
                print("Response Not available")
                return }
            guard let route = response.routes.first else {
                print("No routes inside the response")
                return }
            mapView.addOverlay(route.polyline, level: .aboveRoads)
//            let positioningRect = route.polyline.boundingMapRect
//            mapView.setRegion(MKCoordinateRegion(positioningRect), animated: true)
        }
    }
}
