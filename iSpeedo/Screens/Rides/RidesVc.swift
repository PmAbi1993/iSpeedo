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
    
    lazy var backgroundView: UILabel = {
        let label: UILabel = UILabel(frame: rideHistoryTable.frame)
        label.text = "No Rides saved"
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textAlignment = .center
        return label
    }()
    
    var rideData: [RawRideData] = [RawRideData]() {
        didSet {
            rideHistoryTable.backgroundView = rideData.isEmpty ? self.backgroundView : nil
        }
    }
    var viewModel: RideVCViewModel = RideVCViewModel()
    
    var selectedIndex: Int?
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let rideImage = self.rideData[indexPath.row].rideImage else { return }
        guard let image = UIImage(data: rideImage ) else { return }
        let popUpImage = PopUpImageView()
               popUpImage.configureWith(image: image )
        popUpImage.modalPresentationStyle = .overCurrentContext
        self.present(popUpImage, animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndex = self.selectedIndex else { return }
        guard let destination = segue.destination as? ViewController else { return }
        guard let rideImage = self.rideData[selectedIndex].rideImage else { return }
        guard let image = UIImage(data: rideImage ) else { return }
        destination.image = image
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
