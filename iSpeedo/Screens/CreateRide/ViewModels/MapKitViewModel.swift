//
//  MapKitViewModel.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import CoreLocation

protocol MapKitViewModelDelegate {
    
}

class MapKitViewModel {
    
    private var delegate: MapKitViewModelDelegate?
    
    init(delegate: MapKitViewModelDelegate) { self.delegate = delegate }
}
