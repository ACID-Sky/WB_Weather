//
//  CityHeadView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

final class CityHeadView: UITableViewHeaderFooterView {

    private lazy var image = UIImageView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .orange
        self.setupImage()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupImage() {
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.image.clipsToBounds = true
        self.image.isUserInteractionEnabled = true
        self.image.image = UIImage(systemName: "cloud.fill")
        self.image.backgroundColor = .brown

        self.addSubview(self.image)

        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.image.heightAnchor.constraint(equalToConstant: 250 - 16),
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }

}
