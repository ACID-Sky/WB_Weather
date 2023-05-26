//
//  BackgroundView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 20.05.2023.
//

import UIKit

class BackgroundView: UIView {

    private lazy var imageView = UIImageView()

    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleToFill
        self.imageView.image = UIImage(named: "backgroundWB")

        self.addSubview(self.imageView)

        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension BackgroundView {
    convenience init() {
        self.init(frame: .zero)
    }
}
