//
//  RidesVc.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit
import CoreData


struct RideTableData: Hashable {
    var name: String
}


class RidesVc: UIViewController {

    fileprivate enum Section {
        case rides
    }

    @IBOutlet weak var rideHistoryTable: UITableView!
    fileprivate var dataSource: UITableViewDiffableDataSource<Section, RawRideData>!
    var rideData: [RawRideData] = [RawRideData]()
    var viewModel: RideVCViewModel = RideVCViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.setDefaultBackgroundColor()
        rideHistoryTable.backgroundColor = .clear
        updateTableData()
    }
}

extension RidesVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}

extension RidesVc {
    func updateTableData() {
        viewModel.fetchRides(completionHandler: { self.rideData = $0 ?? [] })
        createSnapShot()
    }
    func configureTableData() {
        
        rideHistoryTable.register(UINib(nibName: RideDataTableCell.identifier,
                                        bundle: nil),
                                  forCellReuseIdentifier: RideDataTableCell.identifier)
        
        dataSource = UITableViewDiffableDataSource<Section,
                                                   RawRideData>(tableView: rideHistoryTable,
                                                                           cellProvider: { (table, index, data) -> UITableViewCell? in
                                                   
                                                                            guard let cell = table.dequeueReusableCell(withIdentifier: RideDataTableCell.identifier) as? RideDataTableCell else {
                                                                                return UITableViewCell()
                                                                            }
                                                                            cell.configureWith(rideData: self.rideData[index.row])
                                                                            return cell
                                                                           })
    }

    func createSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, RawRideData>()
        snapShot.appendSections([.rides])
        snapShot.appendItems(self.rideData)
        dataSource.apply(snapShot)
    }
}
