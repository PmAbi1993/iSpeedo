//
//  CreateRideVC.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import MapKit

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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopMonitoringLocation()
        viewModel.clearCurrentRide()
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
//MARK:- MEthods which render the lines in the mapview
extension CreateRideVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = SettingsViewModel().getCurrentStrokeColor() ?? .red
        renderer.lineWidth = 3
        return renderer
    }
}

//MARK:- Collectionview basic delegates
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


//MARK:- CollectionView Frame configuration
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
//MARK:- View Model Delegates
extension CreateRideVC: MapKitViewModelDelegate {
    func rideDataUpdated(data: [RideData]) {
        itemsToPlot = data
    }
    
    func locationAccessDenied() {
        self.showAlert(title: "Access Denied",
                       message: "Location Access is Denied For this device",
                       okTitle: "Ok")
    }
    
    //MARK:- This method will show the users position the map
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


