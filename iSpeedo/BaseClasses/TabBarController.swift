//
//  TabBarController.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit


// CustomTabbar controller with curved sides
class TabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        curveTabbar()
    }
    
    func curveTabbar() {
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.layer.masksToBounds = true
    }
}
