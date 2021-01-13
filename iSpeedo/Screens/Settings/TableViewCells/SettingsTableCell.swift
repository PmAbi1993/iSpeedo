//
//  SettingsTableCell.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    
    func configureWith(title: String) {
        self.titleLabel.text = title
    }
    
}
