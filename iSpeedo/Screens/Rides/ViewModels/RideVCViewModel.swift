//
//  RideVCViewModel.swift
//  iSpeedo
//
//  Created by admin on 12/01/21.
//

import Foundation

class RideVCViewModel {
    
    //Fetches all the rides that are in the database
    func fetchRides(completionHandler: ([RawRideData]?) -> ()) {
        guard let rides = CoreDataBase.default.fetAllRides() else { return }
        completionHandler(rides)
    }
    
    
    
}
