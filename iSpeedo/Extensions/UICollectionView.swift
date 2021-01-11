//
//  UICollectionView.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit


extension UICollectionView {
    func registerCell(cells: [UICollectionViewCell.Type]) {
        for item in cells {
            register(item, forCellWithReuseIdentifier: item.identifier)
        }
    }
}

