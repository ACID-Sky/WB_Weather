//
//  XLineDayVisualView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 03.05.2023.
//

import UIKit

class XLineDayVisualView: UIView {
    private lazy var verticalStack = UIStackView()


    init(with forecast: WeatherForecastCoreDataModel) {
        super.init(frame: .zero)

        self.setupVerticalStack()
        self.setupWeatherImageView()
        self.setupProbabilityOfPrecipitationLabel(for: forecast)
        self.setupPointAndLine()
        self.setupTimeLabel(for: forecast)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Устанавливаем вертикальный стек для времени, влажности и т.д.
    private func setupVerticalStack() {
        self.verticalStack.translatesAutoresizingMaskIntoConstraints = false
        self.verticalStack.axis = .vertical
        self.verticalStack.spacing = 8
        self.verticalStack.distribution = .fillProportionally
        self.verticalStack.alignment = .fill

        self.addSubview(self.verticalStack)

        NSLayoutConstraint.activate([
            self.verticalStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.verticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.verticalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.verticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    /// Создаём ImageView
    /// - Parameter forecast: прогноз погоды
    private func setupWeatherImageView() {
        let weatherImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        weatherImageView.image = UIImage(named: "cloudAndRain")
        weatherImageView.clipsToBounds = true
        weatherImageView.contentMode = .left

        self.verticalStack.addArrangedSubview(weatherImageView)
    }

    /// Создаём лейбл для параметров
    /// - Parameter text: текст лейбла
    /// - Returns: лейбл для параметров с заданным параметром
    private func setupWeatherLabel(with text: String) -> UILabel {
        let weatherLabel = UILabel()
        weatherLabel.clipsToBounds = true
        weatherLabel.text = text
        weatherLabel.textColor = .black
        weatherLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        weatherLabel.textAlignment = .left
        return weatherLabel
    }

    /// Устанавливаем лейбл вероятности осадков
    /// - Parameter forecast: прогноз погоды
    private func setupProbabilityOfPrecipitationLabel(for  forecast: WeatherForecastCoreDataModel){
        let text = String(Int(forecast.probabilityOfPrecipitation * 100)) + "%"
        let label = self.setupWeatherLabel(with: text)

        self.verticalStack.addArrangedSubview(label)
    }

    /// Устанавливаем точку и линию от системы координат
    private func setupPointAndLine(){
        let point = XLinePointAndLine()

        self.verticalStack.addArrangedSubview(point)
    }

    /// Устанавливаем лейбл времени прогноза погоды
    /// - Parameter forecast: прогноз
    private func setupTimeLabel(for forecast: WeatherForecastCoreDataModel) {
        let timeForecast = Date(timeIntervalSince1970: forecast.dateOfForecast)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(forecast.location?.currentWeather?.timezone ?? 0))
        dateFormatter.locale = Locale(identifier: NSLocalizedString("dateFormatter.locale", comment: "dateFormatter locale"))
        dateFormatter.dateFormat = ValueConverter.shared.getFormat(timeStyleShort: true)

        let timeLabel = self.setupWeatherLabel(with: dateFormatter.string(from: timeForecast))

        self.verticalStack.addArrangedSubview(timeLabel)
    }
}


