//
//  TimeInterval.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit

extension TimeInterval {
    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)

    }
}
