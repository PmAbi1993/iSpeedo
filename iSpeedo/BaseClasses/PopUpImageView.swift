//
//  PopUpImageView.swift
//  iSpeedo
//
//  Created by admin on 13/01/21.
//

import UIKit

class PopUpImageView: UIViewController {

    var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text  = "Ride Map"
        label.textAlignment = .center
        return label
    }()

    var popUpImageView: UIImageView = {
        let imageview: UIImageView = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGessureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExit))
        self.view.addGestureRecognizer(tapGessureRecognizer)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popUpImageView.image = image
    }
    override func loadView() {
        super.loadView()
        
        view.addSubview(popUpImageView)
        popUpImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        popUpImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        popUpImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        popUpImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true

        view.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: popUpImageView.topAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    func configureWith(image: UIImage?) {
        self.image = image
        popUpImageView.image = image
    }
    
    @objc func handleExit() {
        self.dismiss(animated: true, completion: nil)
    }
}
