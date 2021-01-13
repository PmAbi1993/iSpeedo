//
//  Date.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit


extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
