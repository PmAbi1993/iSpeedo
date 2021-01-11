//
//  RidesVc.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit

class RidesVc: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.setDefaultBackgroundColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension RidesVc: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.backgroundColor = .clear
        cell.textLabel?.text = "Ride \(indexPath.row)"
        tableView.backgroundColor = .clear
        return cell
    }
}
