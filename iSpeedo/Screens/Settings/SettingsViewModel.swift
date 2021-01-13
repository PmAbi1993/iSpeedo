//
//  SettingsViewModel.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit

class SettingsViewModel {

    var colorKey: String = "strokeColor"
    func updateStrokeColor(color: AppStrokeColors) {
        UserDefaults.standard.setValue(color.rawValue, forKey: colorKey)
    }
    
    func getCurrentStrokeColor() -> UIColor? {
        return AppStrokeColors(rawValue: UserDefaults.standard.string(forKey: colorKey) ?? "")?.color
        
    }
}
