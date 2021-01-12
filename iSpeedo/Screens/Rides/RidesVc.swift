//
//  RidesVc.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import CoreData

class RidesVc: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.setDefaultBackgroundColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension RidesVc: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataBase.default.fetAllRides()?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.backgroundColor = .clear
        cell.textLabel?.text = "Ride \(indexPath.row)"
        tableView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row%3 {
        case 0:
            CoreDataBase.default.addNewRide(rideData: [.rideTime(time: Date()), .averageSpeed(speed: 12), .distanceCovered(distance: 456)])
            tableView.reloadData()
        case 1:
            guard let rides = CoreDataBase.default.fetAllRides() else { return }
            print(rides.count)
        case 2:
            CoreDataBase.default.clearAllRides()
            tableView.reloadData()
        default:
            break
        }
        
    }
}
