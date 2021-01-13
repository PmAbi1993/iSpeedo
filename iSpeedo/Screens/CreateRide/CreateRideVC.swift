//
//  CreateRideVC.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import MapKit


enum RideData: Equatable {
    case rideTime(time: Date)
    case liveSpeed(speed: Double)
    case distanceCovered(distance: Double)
    case averageSpeed(speed: Double)

    var title: String {
        switch self {
        case .averageSpeed(speed: _):
            return "Average Speed"
        case .rideTime(time: _):
            return "Total Time"
        case .liveSpeed(speed: _):
            return "Live Speed"
        case .distanceCovered(distance: _):
            return "Distance Covered"
        }
    }
    var postFix: String {
        switch self {
        case .averageSpeed(speed: _), .liveSpeed(speed: _):
            return " Km/hr"
        case .distanceCovered(distance: _):
            return " Km"
        case .rideTime:
            return " HH:MM:SS"
        }
    }
    var value: String {
        switch self {
        case .averageSpeed(speed: let speed), .liveSpeed(speed: let speed):
            return String(format: "%.2f", speed) + postFix
        case .distanceCovered(distance: let distance):
            return String(format: "%.2f", distance) + postFix
        case .rideTime(time: let time):
            return Date().timeIntervalSince(time).stringFromTimeInterval()
        }
    }
    
    static func ~=(lhs: RideData, rhs: RideData) -> Bool {
        switch (lhs, rhs) {
        case (.averageSpeed, .averageSpeed):
            return true
        case (.liveSpeed, .liveSpeed):
            return true
        case (.distanceCovered, .distanceCovered):
            return true
        case (.rideTime, .rideTime):
            return true
        default:
            return false
        }
    }
}




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
    
    var itemsToPlot: [RideData] = [ .averageSpeed(speed: 0),
                                    .distanceCovered(distance: 0),
                                    .liveSpeed(speed: 0),
                                    .rideTime(time: Date())] {
        didSet{
            self.rideDataCollectionView.reloadData()
        }
    }
    var rideButtonState: RideButtonStates = .start {
        didSet {
            self.rideButtonOutlet.backgroundColor = rideButtonState.backgroundColor
            self.rideButtonOutlet.setTitleColor(rideButtonState.titleColor, for: .normal)
            self.rideButtonOutlet.setTitle(rideButtonState.title, for: .normal)
            rideDataCollectionView.isHidden = rideButtonState == .start
            self.mapView.showsUserLocation = rideButtonState == .stop
        }
    }
    lazy var viewModel: MapKitViewModel = {
        let viewModel: MapKitViewModel = MapKitViewModel(delegate: self, mapView: mapView)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rideDataCollectionView.registerCell(cells: [RideDataCell.self])
        rideDataCollectionView.backgroundColor = .clear
        mapView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.setDefaultBackgroundColor()
        rideButtonState = .start
    }
    @IBAction func handleRideButtonAction(_ sender: UIButton) {
        
        switch self.rideButtonState {
        case .start:
            viewModel.clearCurrentRide()
            viewModel.startLocationServices()
            viewModel.startMonitoringLocation()
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.rideButtonState = .stop
            }, completion: nil)
        case .stop:
            
            let alertController: UIAlertController = UIAlertController(title: "End Ride",
                                                                       message: "Are you sure you want to end the ride?",
                                                                       preferredStyle: .alert)
            let okAction = UIAlertAction(title: "End Ride", style: .default) { _ in
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.rideButtonState = .start
                    self?.viewModel.stopMonitoringLocation()
                    self?.viewModel.saveRideToDb()
                }, completion: nil)
            }
            let cancelButton = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
            alertController.addAction(cancelButton)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
    }
}
extension CreateRideVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = SettingsViewModel().getCurrentStrokeColor() ?? .red
        renderer.lineWidth = 3
        return renderer
    }
}

extension CreateRideVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsToPlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: RideDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: RideDataCell.identifier,
                                                                                  for: indexPath) as? RideDataCell else { return UICollectionViewCell() }
        cell.configureWithItem(data: self.itemsToPlot[indexPath.row])
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

    }
}

extension CreateRideVC: MapKitViewModelDelegate {
    func rideDataUpdated(data: [RideData]) {
        itemsToPlot = data
    }
    
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
