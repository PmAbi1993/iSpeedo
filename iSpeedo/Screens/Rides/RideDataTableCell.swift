//
//  RideDataTableCell.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit

class RideDataTableCell: UITableViewCell {
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    
    func configureWith(rideData: [RideData]) {
        for data in rideData {
            switch data {
            case .averageSpeed:
                averageSpeedLabel.text = "Average Speed: " + data.value
            case .distanceCovered:
                distanceLabel.text = "Distance Covered: " + data.value
            case .rideTime:
                startDateLabel.text =  "Time Taken: " + data.value
            default:
                break
            }
        }
    }
    
    func configureWith(rideData: RawRideData) {

        print(rideData.distanceTravelled)
        averageSpeedLabel.text = "Average Speed: " + (rideData.averageSpeed ?? "")

        distanceLabel.text = "Distance Covered: " + (rideData.distanceTravelled ?? "")
//
        timeTakenLabel.text =  "Time Taken: " + (rideData.rideTime ?? "")

    }
}
