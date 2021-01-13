//
//  RideVCViewModel.swift
//  iSpeedo
//
//  Created by admin on 12/01/21.
//

import Foundation

class RideVCViewModel {
    
    func fetchRides(completionHandler: ([RawRideData]?) -> ()) {
        guard let rides = CoreDataBase.default.fetAllRides() else { return }
        completionHandler(rides)
    }
    
    
    
}
