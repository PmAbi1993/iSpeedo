//
//  UICollectionViewCell.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit

extension UICollectionViewCell {
    /**
     Syntactic sugar to get the get description of the base class
     - Returns: String
     */
   static var identifier: String {
       return String(describing: self)
   }
}
