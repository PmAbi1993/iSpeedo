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
    @IBOutlet weak var rideDataCollectionView: UICollectionView!
    
    var rideButtonState: RideButtonStates = .start {
        didSet {
            self.rideButtonOutlet.backgroundColor = rideButtonState.backgroundColor
            self.rideButtonOutlet.setTitleColor(rideButtonState.titleColor, for: .normal)
            self.rideButtonOutlet.setTitle(rideButtonState.title, for: .normal)
            rideDataCollectionView.isHidden = rideButtonState == .start
        }
    }
    lazy var viewModel: MapKitViewModel = {
        let viewModel: MapKitViewModel = MapKitViewModel(delegate: self)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rideDataCollectionView.registerCell(cells: [RideDataCell.self])
        rideDataCollectionView.backgroundColor = .clear
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


extension CreateRideVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RideDataCell.identifier,
                                                                            for: indexPath)
        cell.backgroundColor = UIColor.random
        return cell
    }
}



extension CreateRideVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
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


extension CGFloat {
    static var random: CGFloat { return CGFloat(arc4random()) / CGFloat(UInt32.max) }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
           red:   .random,
           green: .random,
           blue:  .random,
           alpha: 1.0
        )
    }
}
