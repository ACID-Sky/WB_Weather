//
//  DailyForecastCollectionViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 01.05.2023.
//

import UIKit
//import CoreData

class DailyForecastCollectionViewCell: UICollectionViewCell {

    private lazy var verticalStackView = UIStackView()
    private lazy var dayForecastLabel = UILabel()
    private lazy var minMaxTemperetureLabel = UILabel()
    private lazy var rightLabel = UILabel()

    private lazy var dateLabel = UILabel()
    private lazy var infoStackView = UIStackView()

    private lazy var rainImage = UIImageView()
    private lazy var rainLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupVerticalStackView()
        self.setupDayForecastLabel()
        self.setupRightLabel()
        self.setupMinMaxTemperetureLabel()

        self.contentView.backgroundColor = UIColor(named: "cellBackgroundColor")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVerticalStackView() {
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verticalStackView.axis = .vertical
        self.verticalStackView.spacing = 4
        self.verticalStackView.distribution = .fillEqually
        self.verticalStackView.alignment = .fill

        self.contentView.addSubview(self.verticalStackView)

        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.verticalStackView.widthAnchor.constraint(equalToConstant: 65),
        ])

        self.setupDateLabel()
        self.setupInfoStackView()
    }

    private func setupDateLabel() {
        self.dateLabel.clipsToBounds = true
        self.dateLabel.textColor = UIColor(named: "cellTextColor")
        self.dateLabel.textAlignment = .center
        self.dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        self.verticalStackView.addArrangedSubview(self.dateLabel)
    }

    private func setupInfoStackView() {
        self.infoStackView.axis = .horizontal
        self.infoStackView.spacing = 0
        self.infoStackView.distribution = .fill
        self.infoStackView.alignment = .fill

        self.verticalStackView.addArrangedSubview(self.infoStackView)

        self.setupRainImage()
        self.setupRainLabel()
    }

    private func setupRainImage() {
        self.rainImage.clipsToBounds = true
        self.rainImage.image = UIImage(named: "cloudAndRain")
        self.rainImage.contentMode = .scaleAspectFit

        self.infoStackView.addArrangedSubview(self.rainImage)
    }

    private func setupRainLabel() {
        self.rainLabel.clipsToBounds = true
        self.rainLabel.textColor = UIColor(named: "cellTextColor")
        self.rainLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        self.infoStackView.addArrangedSubview(self.rainLabel)
    }

    private func setupDayForecastLabel() {
        self.dayForecastLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dayForecastLabel.clipsToBounds = true
        self.dayForecastLabel.textColor = UIColor(named: "cellTextColor")
        self.dayForecastLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.dayForecastLabel.textAlignment = .left

        self.contentView.addSubview(self.dayForecastLabel)

        NSLayoutConstraint.activate([
            self.dayForecastLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.dayForecastLabel.leadingAnchor.constraint(equalTo: self.verticalStackView.trailingAnchor, constant: 8),
            self.dayForecastLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -110)
        ])
    }

    private func setupMinMaxTemperetureLabel() {
        self.minMaxTemperetureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.minMaxTemperetureLabel.clipsToBounds = true
        self.minMaxTemperetureLabel.textColor = UIColor(named: "cellTextColor")
        self.minMaxTemperetureLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.minMaxTemperetureLabel.textAlignment = .right

        self.contentView.addSubview(self.minMaxTemperetureLabel)

        NSLayoutConstraint.activate([
            self.minMaxTemperetureLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.minMaxTemperetureLabel.trailingAnchor.constraint(equalTo: self.rightLabel.leadingAnchor, constant: -10),
            self.minMaxTemperetureLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupRightLabel() {
        self.rightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.rightLabel.clipsToBounds = true
        self.rightLabel.text = "➤"
        self.rightLabel.textColor = UIColor(named: "cellTextColor")
        self.rightLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        self.contentView.addSubview(self.rightLabel)

        NSLayoutConstraint.activate([
            self.rightLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.rightLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
    }

}
extension DailyForecastCollectionViewCell {

    /// Установка данных по погоде
    /// - Parameters:
    ///   - dailyForecast: экземпляр прогноза на день
    func setup(for dailyForecast: Forecast) {
        self.dateLabel.text = dailyForecast.dateText
        self.rainLabel.text = dailyForecast.probabilityOfPrecipitationText
        self.dayForecastLabel.text = dailyForecast.weatherDescription
        self.minMaxTemperetureLabel.text = dailyForecast.minTempText + " - " + dailyForecast.maxTempText
    }
}
