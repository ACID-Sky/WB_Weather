//
//  RundownTableViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import UIKit

class RundownTableViewCell: UITableViewCell {
    private lazy var timeOfDayLabel = UILabel()
    private lazy var verticalStackView = UIStackView()
    private lazy var horizontalStackView = UIStackView()
    private lazy var weatherImageView = UIImageView()
    private lazy var tempLabel = UILabel()
    private lazy var dayForecastLabel = UILabel()

    private lazy var feelsLabel = UILabel()
    private lazy var windLabel = UILabel()
    private lazy var ufIndexLabel = UILabel()
    private lazy var rainLabel = UILabel()
    private lazy var cloudyLabel = UILabel()
    private var feelsLikeImageView: UIImageView?


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = #colorLiteral(red: 0.9146655202, green: 0.9332792163, blue: 0.9809073806, alpha: 1)
        self.setupTimeOfDayLabel()
        self.setupVerticalStackView()
        self.setupLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTimeOfDayLabel() {
        self.timeOfDayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeOfDayLabel.clipsToBounds = true
        self.timeOfDayLabel.text = "Day"
        self.timeOfDayLabel.textColor = .black
        self.timeOfDayLabel.textAlignment = .center
        self.timeOfDayLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        self.contentView.addSubview(self.timeOfDayLabel)

        NSLayoutConstraint.activate([
            self.timeOfDayLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 21),
            self.timeOfDayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
        ])
    }

    private func setupVerticalStackView() {
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verticalStackView.axis = .vertical
        self.verticalStackView.spacing = 4
        self.verticalStackView.distribution = .fillEqually
        self.verticalStackView.alignment = .fill

        self.contentView.addSubview(self.verticalStackView)

        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -240),
            self.verticalStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.verticalStackView.heightAnchor.constraint(equalToConstant: 72),
            self.verticalStackView.widthAnchor.constraint(equalToConstant: 75),
        ])

        self.setupHorizontalStackView()
        self.setupDayForecastLabel()
    }

    private func setupHorizontalStackView() {
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.spacing = 4
        self.horizontalStackView.distribution = .fillEqually
        self.horizontalStackView.alignment = .fill

        self.verticalStackView.addArrangedSubview(self.horizontalStackView)

        self.setupWeatherImage()
        self.setupTempLabel()
    }

    private func setupWeatherImage() {
        self.weatherImageView.clipsToBounds = true
        self.weatherImageView.contentMode = .scaleAspectFit
        self.weatherImageView.tintColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)

        self.horizontalStackView.addArrangedSubview(self.weatherImageView)
    }

    private func setupTempLabel() {
        self.tempLabel.clipsToBounds = true
        self.tempLabel.textColor = .black
        self.tempLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        self.horizontalStackView.addArrangedSubview(self.tempLabel)
    }

    private func setupDayForecastLabel() {
        self.dayForecastLabel.clipsToBounds = true
        self.dayForecastLabel.textColor = .black
        self.dayForecastLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.dayForecastLabel.textAlignment = .center

        self.verticalStackView.addArrangedSubview(self.dayForecastLabel)
    }

    private func setupLabels() {

        let paramsArray = [
            (label: self.dayForecastLabel, imageName: "", descriptionText: ""),
            (label: self.feelsLabel, imageName: "Feels like", descriptionText: NSLocalizedString(
                "RundownTableViewCell.feelsLabel",
                comment: "Feels like"
            )),
            (label: self.windLabel, imageName:  "windcolor", descriptionText: NSLocalizedString(
                "RundownTableViewCell.windLabel",
                comment: "Wind"
            )),
            (label: self.ufIndexLabel, imageName: "Sun", descriptionText: NSLocalizedString(
                "RundownTableViewCell.ufIndexLabel",
                comment: "UV index"
            )),
            (label: self.rainLabel, imageName: "rain", descriptionText: NSLocalizedString(
                "RundownTableViewCell.rainLabel",
                comment: "Possibility of rain"
            )),
            (label: self.cloudyLabel, imageName: "cloudBlue", descriptionText: NSLocalizedString(
                "RundownTableViewCell.cloudyLabel",
                comment: "Cloudiness"
            ))
        ]

        for (index, params) in paramsArray.enumerated() {
            if index != 0 {
                self.setupParamsLabel(
                    for: params.label,
                    withImageName: params.imageName,
                    description: params.descriptionText,
                    afterLabel: paramsArray[index-1].label
                )
            }
        }

    }

    /// Содание и размещение картинки, лейбла описания и полосы
    /// - Parameters:
    ///   - label: Для какого лейбла создаём
    ///   - imageName: Название картинки
    ///   - description: Описание для лейбла
    ///   - afterLabel: За какой лейбл цепляемся?
    private func setupParamsLabel(
        for label: UILabel,
        withImageName: String,
        description: String,
        afterLabel: UILabel
    ){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Day"
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        self.contentView.addSubview(label)

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: withImageName) ?? UIImage(systemName: "globe.europe.africa.fill")!
        if withImageName == "Feels like" {
            self.feelsLikeImageView = imageView
        }
        self.contentView.addSubview(imageView)

        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.clipsToBounds = true
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.text = description

        self.contentView.addSubview(descriptionLabel)

        let blueLineView = UIView()
        blueLineView.translatesAutoresizingMaskIntoConstraints = false
        blueLineView.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)

        self.contentView.addSubview(blueLineView)

        NSLayoutConstraint.activate([
           label.topAnchor.constraint(equalTo: afterLabel.bottomAnchor, constant: 26),
           label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),

            imageView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 26),
            imageView.widthAnchor.constraint(equalToConstant: 26),

            descriptionLabel.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),


            blueLineView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 14),
            blueLineView.heightAnchor.constraint(equalToConstant: 0.5),
            blueLineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            blueLineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
}

extension RundownTableViewCell {

    /// Передача прогноза погоды для установки значений в ячейке
    /// - Parameter forecast: Прогноза средней погоды за часть дня
    func setupForecast(with forecast: Forecast){
        let forecastText = NSLocalizedString(forecast.groupOfWeather.rawValue, comment: "groupOfWeather.___")
        self.timeOfDayLabel.text = forecast.partOfDay
        self.weatherImageView.image = forecast.groupOfWeatherImage
        self.tempLabel.text = forecast.temText
        self.dayForecastLabel.text = forecastText
        self.feelsLikeImageView?.image = forecast.feelsLikeImage
        self.feelsLabel.text = forecast.feelsLikeText
        self.windLabel.text = forecast.windText
        self.ufIndexLabel.text = forecast.UIText
        self.rainLabel.text = forecast.probabilityOfPrecipitationText
        self.cloudyLabel.text = forecast.cloudy

    }
}
