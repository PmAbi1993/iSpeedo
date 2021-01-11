//
//  CreateRideVC.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import MapKit


enum RideButtonStates {
    
    case start
    case stop
    
    var backgroundColor: UIColor {
        switch self {
        case .start:
            return .black
        case .stop:
            return .red
        }
    }
    var titleColor: UIColor {
        switch self {
        case .start:
            return .white
        case .stop:
            return .white
        }
    }
    var title: String {
        switch self {
        case .start:
            return "Start Ride"
        case .stop:
            return "End Ride"
        }
    }
}


class CreateRideVC: UIViewController {

    @IBOutlet weak var rideButtonOutlet: UIButton!
    @IBOutlet weak var mapView: MKMapView!
   
    var rideButtonState: RideButtonStates = .start {
        didSet {
            self.rideButtonOutlet.backgroundColor = rideButtonState.backgroundColor
            self.rideButtonOutlet.setTitleColor(rideButtonState.titleColor, for: .normal)
            self.rideButtonOutlet.setTitle(rideButtonState.title, for: .normal)
        }
    }
    
    
    lazy var viewModel: MapKitViewModel = {
        let viewModel: MapKitViewModel = MapKitViewModel(delegate: self)
        return viewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.setDefaultBackgroundColor()
        rideButtonState = .start
    }
    @IBAction func handleRideButtonAction(_ sender: UIButton) {        
        UIView.animate(withDuration: 0.3, animations: {
            self.rideButtonState = (self.rideButtonState == .start) ? .stop : .start
        }, completion: nil)
    }
}


extension CreateRideVC {
    
    
}

extension CreateRideVC: MapKitViewModelDelegate {
    func locationAccessDenied() {
        self.showAlert(title: "Access Denied",
                       message: "Location Access is Denied For this device",
                       okTitle: "Ok")
    }
    
    func locationUpdated(location: CLLocation) {
        let presentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                     longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: presentLocation,
                                        span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
}
