//
//  EmptyViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 21.04.2023.
//

import UIKit

class EmptyViewController: UIViewController {

    private lazy var image = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupImage()
    }

    private func setupImage() {
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.image.clipsToBounds = true
        self.image.isUserInteractionEnabled = true
        self.image.image = UIImage(systemName: "location.slash.circle")
        self.image.tintColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)

        self.view.addSubview(self.image)

        NSLayoutConstraint.activate([
            self.image.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.image.heightAnchor.constraint(equalToConstant: 200),
            self.image.widthAnchor.constraint(equalToConstant: 200),
        ])
    }

}
