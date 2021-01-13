//
//  SettingVC.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
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


class SettingVC: UIViewController {

    var itemsToPlot: [SettingsItems] = SettingsItems.allCases
    var viewModel: SettingsViewModel = SettingsViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.setDefaultBackgroundColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToPlot.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = itemsToPlot[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch itemsToPlot[indexPath.row] {
        case .changeStrokeColor:
            handleActionSheet()
        case .clearDatabase:
            handleItemDelete()
        }
    }
    fileprivate func handleItemDelete() {
        let alertController: UIAlertController = UIAlertController(title: "Clear Database",
                                                                   message: "This will clear the application database", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            CoreDataBase.default.clearAllRides()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func handleActionSheet() {
        let popUp = PopUp(title: "Select Color",
                          items: AppStrokeColors.allCases) { selectedColor in
            self.viewModel.updateStrokeColor(color: selectedColor)
        }
        self.present(popUp, animated: true, completion: nil)
    }
}
