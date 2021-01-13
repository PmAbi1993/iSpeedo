//
//  CreateRideModels.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit

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

