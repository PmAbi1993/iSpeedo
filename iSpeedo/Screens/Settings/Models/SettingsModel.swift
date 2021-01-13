//
//  SettingsModel.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit


enum SettingsItems: CaseIterable {
    case changeStrokeColor
    case clearDatabase
    
    var title: String {
        switch self {
        case .changeStrokeColor:
            return "Change Stroke Color"
        case .clearDatabase:
            return "Clear Database"
        }
    }
}


enum AppStrokeColors: RawRepresentable, CaseIterable {
    typealias RawValue = String

    init?(rawValue: String) {
        switch rawValue {
        case "red":
            self = .red
        case "green":
            self = .green
        case "blue":
            self = .blue
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .red:
            return "red"
        case .green:
            return "green"
        case .blue:
            return "blue"
        }
    }
    
    case red
    case blue
    case green
    
    
    var color: UIColor {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        }
    }
}
