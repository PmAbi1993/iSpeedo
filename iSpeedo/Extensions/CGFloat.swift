//
//  CGFloat.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit


extension CGFloat {
    static var random: CGFloat { return CGFloat(arc4random()) / CGFloat(UInt32.max) }
}
