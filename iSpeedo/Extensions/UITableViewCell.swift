//
//  UITableViewCell.swift
//  iSpeedo
//
//  Created by admin on 12/01/21.
//

import UIKit

extension UITableViewCell {
    /**
     Syntactic sugar to get the get description of the base class
     - Returns: String
     */
   static var identifier: String {
       return String(describing: self)
   }
}

