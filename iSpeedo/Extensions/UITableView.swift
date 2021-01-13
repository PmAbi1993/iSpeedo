//
//  UITableView.swift
//  iSpeedo
//
//  Created by admin on 12/01/21.
//

import Foundation

import UIKit

extension UITableView {
    func registerWith(cells: [UITableViewCell.Type]) {
        for cell in cells {
            self.register(cell,
                          forCellReuseIdentifier: cell.identifier)
        }
    }
}
