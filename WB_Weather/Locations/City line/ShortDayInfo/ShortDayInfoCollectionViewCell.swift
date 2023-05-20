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
        self.timeLabel.textAlignment = .center
        self.timeLabel.isUserInteractionEnabled = true
        self.timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        self.contentView.addSubview(self.timeLabel)
        let third = self.contentView.frame.height/3

        NSLayoutConstraint.activate([
            self.timeLabel.widthAnchor.constraint(equalToConstant: self.contentView.frame.width),
            self.timeLabel.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: third),
            self.timeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),

        ])
    }

    private func setuPicture() {
        self.picture.backgroundColor = .black
        self.picture.contentMode = .scaleAspectFit
        self.picture.translatesAutoresizingMaskIntoConstraints = false
        self.picture.backgroundColor = .clear
        self.picture.tintColor = .orange

        self.contentView.addSubview(self.picture)

        NSLayoutConstraint.activate([
            self.picture.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.picture.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.picture.heightAnchor.constraint(equalToConstant: (self.contentView.frame.width-8)*2/3),
            self.picture.widthAnchor.constraint(equalToConstant: self.contentView.frame.width - 8),
        ])
    }

    private func setupDegreesLabel() {
        self.degresLabel.translatesAutoresizingMaskIntoConstraints = false
        self.degresLabel.textAlignment = .center
        self.degresLabel.isUserInteractionEnabled = true
        self.degresLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        self.contentView.addSubview(self.degresLabel)
        let third = self.contentView.frame.height/3

        NSLayoutConstraint.activate([
            self.degresLabel.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -third),
            self.degresLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        ])
    }

    func setup(with weatherForecastModel: WeatherForecastCoreDataModel) {

        let date = Date()
        let time = Date(timeIntervalSince1970: weatherForecastModel.dateOfForecast)
        if date < time + 3*1800 && date >= time - 3*1800 {
            self.contentView.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        } else {
            self.contentView.backgroundColor = .clear
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(weatherForecastModel.location?.currentWeather?.timezone ?? 0))
        dateFormatter.locale = Locale(identifier: "dateFormatter.locale".localized)
        dateFormatter.dateFormat = ValueConverter.shared.getFormat(timeStyleShort: true)

        self.timeLabel.text = dateFormatter.string(from: time)
        self.picture.image = UIImage(named: weatherForecastModel.weatherIcon ?? "rain") ?? UIImage(named: "rain")!
        self.degresLabel.text = ValueConverter.shared.getTemp(for: weatherForecastModel.temp) + "º"
    }
}
