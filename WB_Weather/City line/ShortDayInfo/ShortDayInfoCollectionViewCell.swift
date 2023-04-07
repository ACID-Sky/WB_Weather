//
//  ShortDayInfoCollectionViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import UIKit

final class ShortDayInfoCollectionViewCell: UICollectionViewCell {

    private lazy var timeLabel = UILabel()
    private lazy var picture = UIImageView()
    private lazy var degresLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTimeLabel()
        self.setuPicture()
        self.setupDegreesLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTimeLabel() {
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.clipsToBounds = true
        self.timeLabel.isUserInteractionEnabled = true
//        self.timeLabel.text = "More info for 24 hours"
        self.timeLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)

        self.contentView.addSubview(self.timeLabel)

        NSLayoutConstraint.activate([
            self.timeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.timeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
//            self.timeLabel.widthAnchor.constraint(equalToConstant: 16),
        ])
    }

    private func setuPicture() {
        self.picture.backgroundColor = .black
        self.picture.contentMode = .scaleAspectFill
//        self.picture.image = UIImage(named: "")
        self.picture.translatesAutoresizingMaskIntoConstraints = false
        self.picture.backgroundColor = .systemBackground
        self.picture.tintColor = .orange

        self.contentView.addSubview(self.picture)

        NSLayoutConstraint.activate([
            self.picture.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.picture.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 4),
//            self.picture.heightAnchor.constraint(equalToConstant: 16),
//            self.picture.widthAnchor.constraint(equalToConstant: 16),
        ])
    }

    private func setupDegreesLabel() {
        self.degresLabel.translatesAutoresizingMaskIntoConstraints = false
        self.degresLabel.clipsToBounds = true
        self.degresLabel.isUserInteractionEnabled = true
//        self.degresLabel.text = "More info for 24 hours"
        self.degresLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)

        self.contentView.addSubview(self.degresLabel)

        NSLayoutConstraint.activate([
            self.degresLabel.topAnchor.constraint(equalTo: self.picture.bottomAnchor),
            self.degresLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.degresLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            self.degresLabel.widthAnchor.constraint(equalToConstant: 16),
        ])
    }
    func setup(with toDay: ShortDayInfo) {
        self.timeLabel.text = toDay.time
        self.picture.image = UIImage(systemName: toDay.image)!
        self.degresLabel.text = String(toDay.degrees) + "º"
    }
}
