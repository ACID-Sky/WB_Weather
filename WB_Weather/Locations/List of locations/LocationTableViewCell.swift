//
//  LocationTableViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 09.05.2023.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    private lazy var locationimageView = UIImageView()
    private lazy var locationNameLabel = UILabel()
    private lazy var currentTempLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Palette.cellBackgroundColor
        self.setupView()
        self.setupParams()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Palette.borderColor.cgColor
        self.clipsToBounds = true
    }

    private func setupParams() {
        self.locationimageView.translatesAutoresizingMaskIntoConstraints = false
        self.locationimageView.clipsToBounds = true
        self.locationimageView.contentMode = .center
        self.locationimageView.tintColor = Palette.cellTextColor

        self.contentView.addSubview(self.locationimageView)

        self.locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.locationNameLabel.clipsToBounds = true
        self.locationNameLabel.textColor = Palette.cellTextColor
        self.locationNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.locationNameLabel.textAlignment = .left

        self.contentView.addSubview(self.locationNameLabel)

        self.currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentTempLabel.clipsToBounds = true
        self.currentTempLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.currentTempLabel.textAlignment = .right

        self.contentView.addSubview(self.currentTempLabel)

        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalToConstant: 100),

            self.locationimageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.locationimageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.locationimageView.trailingAnchor.constraint(equalTo: self.locationNameLabel.leadingAnchor, constant: -8),
            self.locationimageView.widthAnchor.constraint(equalToConstant: 32),
            self.locationimageView.heightAnchor.constraint(equalToConstant: 32),


            self.locationNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.locationNameLabel.leadingAnchor.constraint(equalTo: self.locationimageView.trailingAnchor, constant: 8),
            self.locationNameLabel.trailingAnchor.constraint(equalTo: self.currentTempLabel.leadingAnchor, constant: -16),

            self.currentTempLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.currentTempLabel.leadingAnchor.constraint(equalTo: self.locationNameLabel.trailingAnchor, constant: 16),
            self.currentTempLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
        ])
    }

}

extension LocationTableViewCell {
    func setupLocation(for locationModel: LocationsCoreDataModel){
        if locationModel.locationID == 0 {
            self.locationimageView.image = UIImage(systemName: "location.fill")!
        }
        self.locationNameLabel.text = locationModel.locationName

        guard let currentTemp = locationModel.currentWeather?.mainTemp else { return }
        self.currentTempLabel.text = ValueConverter.shared.getTemp(for: currentTemp) + "º"
        if currentTemp > 0 {
            self.currentTempLabel.textColor = .systemGreen
        } else {
            self.currentTempLabel.textColor = .systemBlue
        }
    }
}
