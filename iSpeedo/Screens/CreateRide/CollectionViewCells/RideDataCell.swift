//
//  RideDataCell.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit

class RideDataCell: UICollectionViewCell {
    
    var dataLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "999 KM/Hr"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Average Speed"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialiseViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialiseViews()
    }
    func initialiseViews() {
        
        contentView.addSubview(dataLabel)
        dataLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        dataLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        dataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        dataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
    }
    
    func configureWithItem(data: RideData) {
        self.titleLabel.text = data.title
        self.dataLabel.text = data.value        
    }
}

