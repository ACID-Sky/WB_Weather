//
//  DailyForecastTableViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

final class TimeForecastTableViewCell: UITableViewCell {

    private lazy var dayLabel = UILabel()
    private lazy var timeAndTempVerticalStack = UIStackView()
    private lazy var paramsHorizontalStack = UIStackView()

    private lazy var timeLabel = UILabel()
    private lazy var currentTempLabel = UILabel()

    private lazy var dayForecastLabel = UILabel()
    private lazy var feelsLikeLabel = UILabel()
    private lazy var windLabel = UILabel()
    private lazy var rainLabel = UILabel()
    private lazy var cloudyLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = #colorLiteral(red: 0.9146655202, green: 0.9332792163, blue: 0.9809073806, alpha: 1)
        self.setupDayLabel()
        self.setupTimeAndTempVerticalStack()
        self.setupParamsHorizontalStack()
        self.setupBlueLineView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDayLabel() {
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dayLabel.clipsToBounds = true
        self.dayLabel.text = "dw DD/MM"
        self.dayLabel.textColor = .black
        self.dayLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.dayLabel.textAlignment = .left

        self.contentView.addSubview(self.dayLabel)

        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.dayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
        ])
    }

    /// Устанавливаем вертикальный стек для времени и текущей температуры и заполняем его временем и температурой
    private func setupTimeAndTempVerticalStack() {
        self.timeAndTempVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        self.timeAndTempVerticalStack.axis = .vertical
        self.timeAndTempVerticalStack.spacing = 8
        self.timeAndTempVerticalStack.distribution = .fillProportionally
        self.timeAndTempVerticalStack.alignment = .fill

        self.contentView.addSubview(self.timeAndTempVerticalStack)

        NSLayoutConstraint.activate([
            self.timeAndTempVerticalStack.topAnchor.constraint(equalTo: self.dayLabel.bottomAnchor, constant: 8),
            self.timeAndTempVerticalStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.timeAndTempVerticalStack.heightAnchor.constraint(equalToConstant: 8*7),
            self.timeAndTempVerticalStack.widthAnchor.constraint(equalToConstant: 71),
        ])

        self.setupTimeLabel()
        self.setupCurrentTempLabel()
    }

    /// Устанавливаем горизонтальный стке для остальных параметров + добавляем 3 вертикальных стека внутрь
    private func setupParamsHorizontalStack(){
        self.paramsHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        self.paramsHorizontalStack.axis = .horizontal
        self.paramsHorizontalStack.spacing = 8
        self.paramsHorizontalStack.distribution = .fillProportionally
        self.paramsHorizontalStack.alignment = .fill

        self.contentView.addSubview(self.paramsHorizontalStack)

        NSLayoutConstraint.activate([
            self.paramsHorizontalStack.topAnchor.constraint(equalTo: self.dayLabel.bottomAnchor, constant: 8),
            self.paramsHorizontalStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.paramsHorizontalStack.leadingAnchor.constraint(equalTo: self.timeAndTempVerticalStack.trailingAnchor),
            self.paramsHorizontalStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            self.paramsHorizontalStack.heightAnchor.constraint(equalToConstant: 16*7),
        ])

        self.setupImagesParametrsStack()
        self.setupLabelsParametrsStack()
        self.setupValuesParametrsStack()
    }

    private func setupTimeLabel() {
        self.timeLabel.clipsToBounds = true
        self.timeLabel.text = "12:00"
        self.timeLabel.textColor = .systemGray
        self.timeLabel.textAlignment = .left
        self.timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        self.timeAndTempVerticalStack.addArrangedSubview(self.timeLabel)
    }

    private func setupCurrentTempLabel() {
        self.currentTempLabel.clipsToBounds = true
        self.currentTempLabel.text = "00º"
        self.currentTempLabel.textColor = .black
        self.currentTempLabel.textAlignment = .left
        self.currentTempLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        self.timeAndTempVerticalStack.addArrangedSubview(self.currentTempLabel)
    }

    /// Создаём горизонтальный стекдля параметров
    /// - Returns: возвращает горизонтальный стек
    private func setupVerticalStackView(alignment:  UIStackView.Alignment) -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .vertical
        horizontalStackView.spacing = 8
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.alignment = alignment
        return horizontalStackView
    }

    /// Создаём ImageView
    /// - Parameter imageName: название картинки
    /// - Returns: ImageView с заданным названием
    private func setupWeatherImageView(with imageName: String) -> UIImageView {
        let weatherImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        weatherImageView.clipsToBounds = true
        weatherImageView.image = UIImage(named: imageName)
        weatherImageView.contentMode = .left
        return weatherImageView
    }

    /// Создаём лейбл для параметров
    /// - Parameter text: текст лейбла
    /// - Returns: лейбл для параметров с заданным параметром
    private func setupWeatherLabel(with text: String) -> UILabel {
        let weatherLabel = UILabel()
        weatherLabel.clipsToBounds = true
        weatherLabel.textColor = .black
        weatherLabel.text = text
        weatherLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        weatherLabel.textAlignment = .left
        return weatherLabel
    }

    /// Устанавливаем вертикальный стек с картинками, которые не будут меняться
    private func setupImagesParametrsStack() {
        let stack = self.setupVerticalStackView(alignment: .leading)
        let moonImage = self.setupWeatherImageView(with: "moon")
        let windImage = self.setupWeatherImageView(with: "windcolor")
        let rainImage = self.setupWeatherImageView(with: "rain")
        let cloudImage = self.setupWeatherImageView(with: "cloudBlue")

        stack.addArrangedSubview(moonImage)
        stack.addArrangedSubview(windImage)
        stack.addArrangedSubview(rainImage)
        stack.addArrangedSubview(cloudImage)

        self.paramsHorizontalStack.addArrangedSubview(stack)
    }

    /// Устанавливаем вертикальный стек с лейблами, которые не будут меняться (кроме одного)
    private func setupLabelsParametrsStack() {
        let stack = self.setupVerticalStackView(alignment: .leading)

        self.dayForecastLabel.clipsToBounds = true
        self.dayForecastLabel.text = "It could rain a lot"
        self.dayForecastLabel.textColor = .black
        self.dayForecastLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.dayForecastLabel.textAlignment = .left

        let windLabel = self.setupWeatherLabel(with: "forecast.wind".localized)
        let rainLabel = self.setupWeatherLabel(with: "forecast.rainfall".localized)
        let cloudLabel = self.setupWeatherLabel(with: "forecast.cloudy".localized)

        stack.addArrangedSubview(self.dayForecastLabel)
        stack.addArrangedSubview(windLabel)
        stack.addArrangedSubview(rainLabel)
        stack.addArrangedSubview(cloudLabel)

        self.paramsHorizontalStack.addArrangedSubview(stack)
    }

    /// Устанавливаем вертикальный стек с лейблами, которые будут меняться
    private func setupValuesParametrsStack() {
        let stack = self.setupVerticalStackView(alignment: .trailing)

        self.feelsLikeLabel.clipsToBounds = true
        self.feelsLikeLabel.text = "Feels like 0º"
        self.feelsLikeLabel.textColor = .black
        self.feelsLikeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.feelsLikeLabel.textAlignment = .right

        self.windLabel.clipsToBounds = true
        self.windLabel.text = ValueConverter.shared.getWindSpeed(for: 3 ) + " NNW"
        self.windLabel.textColor = .systemGray
        self.windLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.windLabel.textAlignment = .right

        self.rainLabel.clipsToBounds = true
        self.rainLabel.text = "50%"
        self.rainLabel.textColor = .systemGray
        self.rainLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.rainLabel.textAlignment = .right

        self.cloudyLabel.clipsToBounds = true
        self.cloudyLabel.text = "50%"
        self.cloudyLabel.textColor = .systemGray
        self.cloudyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.cloudyLabel.textAlignment = .right

        stack.addArrangedSubview(self.feelsLikeLabel)
        stack.addArrangedSubview(self.windLabel)
        stack.addArrangedSubview(self.rainLabel)
        stack.addArrangedSubview(self.cloudyLabel)

        self.paramsHorizontalStack.addArrangedSubview(stack)
    }

    private func setupBlueLineView() {
        let blueLineView = UIView()
        blueLineView.translatesAutoresizingMaskIntoConstraints = false
        blueLineView.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)

        self.contentView.addSubview(blueLineView)

        NSLayoutConstraint.activate([
            blueLineView.topAnchor.constraint(equalTo: self.paramsHorizontalStack.bottomAnchor, constant: 8),
            blueLineView.heightAnchor.constraint(equalToConstant: 1),
            blueLineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            blueLineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }

}

extension TimeForecastTableViewCell {

    /// Передаём прогноз погоды для установки значений
    /// - Parameters:
    ///   - weatherForecastModel: Прогноз погоды на временной промежуток
    ///   - index: индекс ячейки для понимания необходимости указывать дату на ячейке
    func setupWeather(for weatherForecastModel: WeatherForecastCoreDataModel, index: IndexPath){
        let dt = Int(weatherForecastModel.dateOfForecast)
        let timezone = Int(weatherForecastModel.location?.currentWeather?.timezone ?? 0)
        let time = Date(timeIntervalSince1970: weatherForecastModel.dateOfForecast)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = Locale(identifier: "dateFormatter.locale".localized)
        dateFormatter.dateFormat = ValueConverter.shared.getFormat(timeStyleShort: true)
        self.timeLabel.text = dateFormatter.string(from: time)

        dateFormatter.dateFormat = "E, dd/MM"
        self.dayLabel.text = dateFormatter.string(from: time)
        if index.row != 0 && (dt + timezone) % 86400 >= 10800 {
            self.dayLabel.text = ""
        }

        self.currentTempLabel.text = ValueConverter.shared.getTemp(for: weatherForecastModel.temp) + "º"
        self.dayForecastLabel.text = weatherForecastModel.weatherDescription
        self.feelsLikeLabel.text = "forecast.feelsLike".localized +
        ValueConverter.shared.getTemp(for: weatherForecastModel.feelsLike) +
        "º"
        let windDirection = CommonFunctions().getWindDirection(for: weatherForecastModel.windDeg)
        self.windLabel.text = ValueConverter.shared.getWindSpeed(for: weatherForecastModel.windSpeed) + " " + windDirection
        self.rainLabel.text = String(Int(weatherForecastModel.probabilityOfPrecipitation * 100)) + "%"
        self.cloudyLabel.text = String(Int(weatherForecastModel.cloudsAll)) + "%"
    }

}
