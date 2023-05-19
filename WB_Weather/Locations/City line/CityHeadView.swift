//
//  CityHeadView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
// Шапка основного экрана с текущей погодой

import UIKit
import CoreData

final class CityHeadView: UIView {

    private var coreDataLocationService: CoreDataLocationService?

    private lazy var ellipseImage = UIImageView()

    private lazy var sunriseImage = UIImageView()
    private lazy var sunriseLabel = UILabel()

    private lazy var sunsetImage = UIImageView()
    private lazy var sunsetLabel = UILabel()

    private lazy var labelStackView = UIStackView()
    private lazy var minMaxTemperetureLabel = UILabel()
    private lazy var currentTemperetureLabel = UILabel()
    private lazy var dayForecastLabel = UILabel()
    private lazy var infoStackView = UIStackView()

    private lazy var cloudssunImage = UIImageView()
    private lazy var cloudssunLabel = UILabel()
    private lazy var windcolorImage = UIImageView()
    private lazy var windcolorLabel = UILabel()
    private lazy var rainImage = UIImageView()
    private lazy var rainLabel = UILabel()

    private lazy var currentDateAndTimeLabel = UILabel()

    init(location: Locations) {
        super.init(frame: .zero)
        self.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        self.coreDataLocationService = CoreDataLocationServiceImp(delegate: self, locationID: location.id)
        self.setupEllipseImage()
        self.setupSunriseImage()
        self.setupSunriseLabel()
        self.setupSunsetImage()
        self.setupSunsetLabel()
        self.setuplabelStackView()
        self.setupCurrentDateAndTimeLabel()
        self.setupWeather(for: location)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupEllipseImage() {
        self.ellipseImage.translatesAutoresizingMaskIntoConstraints = false
        self.ellipseImage.clipsToBounds = true
        self.ellipseImage.isUserInteractionEnabled = true
        self.ellipseImage.image = UIImage(named: "ellipse")
        self.ellipseImage.backgroundColor = .clear

        self.addSubview(self.ellipseImage)

        NSLayoutConstraint.activate([
            self.ellipseImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 17),
            self.ellipseImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 33),
            self.ellipseImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -31),
            self.ellipseImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -72),
        ])
    }

    private func setupSunriseImage() {
        self.sunriseImage.translatesAutoresizingMaskIntoConstraints = false
        self.sunriseImage.clipsToBounds = true
        self.sunriseImage.image = UIImage(named: "sunrise")
        self.sunriseImage.tintColor = .yellow

        self.addSubview(self.sunriseImage)

        NSLayoutConstraint.activate([
            self.sunriseImage.topAnchor.constraint(equalTo: self.ellipseImage.bottomAnchor, constant: 6),
            self.sunriseImage.centerXAnchor.constraint(equalTo: self.ellipseImage.leadingAnchor),
            self.sunriseImage.heightAnchor.constraint(equalToConstant: 17),
            self.sunriseImage.widthAnchor.constraint(equalToConstant: 17),
        ])
    }

    private func setupSunriseLabel() {
        self.sunriseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sunriseLabel.textAlignment = .center
        self.sunriseLabel.numberOfLines = 2
        self.sunriseLabel.text = "HH:MM"
        self.sunriseLabel.textColor = .systemBackground
        self.sunriseLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        self.addSubview(self.sunriseLabel)

        NSLayoutConstraint.activate([
            self.sunriseLabel.topAnchor.constraint(equalTo: self.sunriseImage.bottomAnchor, constant: 8),
            self.sunriseLabel.centerXAnchor.constraint(equalTo: self.sunriseImage.centerXAnchor),
            self.sunriseLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupSunsetImage() {
        self.sunsetImage.translatesAutoresizingMaskIntoConstraints = false
        self.sunsetImage.clipsToBounds = true
        self.sunsetImage.image = UIImage(named: "sunset")
        self.sunsetImage.tintColor = .yellow

        self.addSubview(self.sunsetImage)

        NSLayoutConstraint.activate([
            self.sunsetImage.topAnchor.constraint(equalTo: self.ellipseImage.bottomAnchor, constant: 6),
            self.sunsetImage.centerXAnchor.constraint(equalTo: self.ellipseImage.trailingAnchor),
            self.sunsetImage.heightAnchor.constraint(equalToConstant: 17),
            self.sunsetImage.widthAnchor.constraint(equalToConstant: 17),
        ])
    }

    private func setupSunsetLabel() {
        self.sunsetLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sunsetLabel.textAlignment = .center
        self.sunsetLabel.numberOfLines = 2
        self.sunsetLabel.text = "HH:MM"
        self.sunsetLabel.textColor = .systemBackground
        self.sunsetLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        self.addSubview(self.sunsetLabel)

        NSLayoutConstraint.activate([
            self.sunsetLabel.topAnchor.constraint(equalTo: self.sunsetImage.bottomAnchor, constant: 8),
            self.sunsetLabel.centerXAnchor.constraint(equalTo: self.sunsetImage.centerXAnchor),
            self.sunsetLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setuplabelStackView() {
        self.labelStackView.translatesAutoresizingMaskIntoConstraints = false
        self.labelStackView.axis = .vertical
        self.labelStackView.spacing = 8
        self.labelStackView.distribution = .equalCentering
        self.labelStackView.alignment = .center

        self.addSubview(self.labelStackView)

        NSLayoutConstraint.activate([
            self.labelStackView.topAnchor.constraint(equalTo: self.ellipseImage.topAnchor, constant: 16),
            self.labelStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.labelStackView.bottomAnchor.constraint(equalTo: self.sunriseImage.bottomAnchor),
            self.labelStackView.leadingAnchor.constraint(equalTo: self.ellipseImage.leadingAnchor, constant: 16),
            self.labelStackView.trailingAnchor.constraint(equalTo: self.ellipseImage.trailingAnchor, constant: -16),
        ])

        self.setupMinMaxTemperetureLabel()
        self.setupCurrentTemperetureLabel()
        self.setupDayForecastLabel()
        self.setupInfoStackView()
    }

    private func setupMinMaxTemperetureLabel() {
        self.minMaxTemperetureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.minMaxTemperetureLabel.clipsToBounds = true
        self.minMaxTemperetureLabel.text = "minº/maxº"
        self.minMaxTemperetureLabel.textColor = .systemBackground
        self.minMaxTemperetureLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.minMaxTemperetureLabel.textAlignment = .center

        self.labelStackView.addArrangedSubview(self.minMaxTemperetureLabel)
    }

    private func setupCurrentTemperetureLabel() {
        self.currentTemperetureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentTemperetureLabel.clipsToBounds = true
        self.currentTemperetureLabel.text = "Currentº"
        self.currentTemperetureLabel.textColor = .systemBackground
        self.currentTemperetureLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        self.currentTemperetureLabel.textAlignment = .center

        self.labelStackView.addArrangedSubview(self.currentTemperetureLabel)
    }

    private func setupDayForecastLabel() {
        self.dayForecastLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dayForecastLabel.clipsToBounds = true
        self.dayForecastLabel.text = "It could rain a lot"
        self.dayForecastLabel.textColor = .systemBackground
        self.dayForecastLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.dayForecastLabel.textAlignment = .center

        self.labelStackView.addArrangedSubview(self.dayForecastLabel)
    }

    private func setupInfoStackView() {
        self.infoStackView.translatesAutoresizingMaskIntoConstraints = false
        self.infoStackView.axis = .horizontal
        self.infoStackView.spacing = 5
        self.infoStackView.distribution = .fillEqually
        self.infoStackView.alignment = .fill

        self.labelStackView.addArrangedSubview(self.infoStackView)
        self.setupCloudssunImage()
        self.setupCloudssunLabel()
        self.setupWindcolorImage()
        self.setupWindcolorLabel()
        self.setupRainImage()
        self.setupRainLabel()
    }

    private func setupCloudssunImage() {
        self.cloudssunImage.translatesAutoresizingMaskIntoConstraints = false
        self.cloudssunImage.clipsToBounds = true
        self.cloudssunImage.contentMode = .scaleAspectFit
        self.cloudssunImage.image = UIImage(named: "cloudAndSun")

        self.infoStackView.addArrangedSubview(self.cloudssunImage)
    }

    private func setupCloudssunLabel() {
        self.cloudssunLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cloudssunLabel.clipsToBounds = true
        self.cloudssunLabel.text = "10%"
        self.cloudssunLabel.textColor = .systemBackground
        self.cloudssunLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        self.infoStackView.addArrangedSubview(self.cloudssunLabel)
    }

    private func setupWindcolorImage() {
        self.windcolorImage.translatesAutoresizingMaskIntoConstraints = false
        self.windcolorImage.clipsToBounds = true
        self.windcolorImage.image = UIImage(named: "windcolor")
        self.windcolorImage.contentMode = .scaleAspectFit

        self.infoStackView.addArrangedSubview(self.windcolorImage)
    }

    private func setupWindcolorLabel() {
        self.windcolorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.windcolorLabel.clipsToBounds = true
        self.windcolorLabel.text = ValueConverter.shared.getWindSpeed(for: 3)
        self.windcolorLabel.textColor = .systemBackground
        self.windcolorLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        self.infoStackView.addArrangedSubview(self.windcolorLabel)
    }

    private func setupRainImage(){
        self.rainImage.translatesAutoresizingMaskIntoConstraints = false
        self.rainImage.clipsToBounds = true
        self.rainImage.image = UIImage(named: "rain")
        self.rainImage.contentMode = .scaleAspectFit

        self.infoStackView.addArrangedSubview(self.rainImage)
    }

    private func setupRainLabel() {
        self.rainLabel.translatesAutoresizingMaskIntoConstraints = false
        self.rainLabel.clipsToBounds = true
        self.rainLabel.text = "75%"
        self.rainLabel.textColor = .systemBackground
        self.rainLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        self.infoStackView.addArrangedSubview(self.rainLabel)
    }

    private func setupCurrentDateAndTimeLabel() {
        self.currentDateAndTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentDateAndTimeLabel.clipsToBounds = true
        self.currentDateAndTimeLabel.text = "HH:MM, dw DD month"
        self.currentDateAndTimeLabel.textColor = .yellow
        self.currentDateAndTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        self.addSubview(self.currentDateAndTimeLabel)

        NSLayoutConstraint.activate([
            self.currentDateAndTimeLabel.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 8),
            self.currentDateAndTimeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }

    /// Устанавливаем значение для текущей погода на View
    /// - Parameter forecast: текущий прогноз погоды CurrentWeatherCoreDataModel
    private func setupParametrs(for forecast: CurrentWeatherCoreDataModel){

        let date = Date(timeIntervalSince1970: forecast.dateOfForecast)
        let surise = Date(timeIntervalSince1970: forecast.sysSunrise)
        let sunset = Date(timeIntervalSince1970: forecast.sysSunset)
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(forecast.timezone))
        dateFormatter.locale = Locale(identifier: NSLocalizedString("dateFormatter.locale", comment: "dateFormatter locale"))
        dateFormatter.dateFormat = ValueConverter.shared.getFormat(timeStyleShort: true)

        self.sunriseLabel.text = dateFormatter.string(from: surise)
        self.sunsetLabel.text = dateFormatter.string(from: sunset)

        dateFormatter.dateFormat = ValueConverter.shared.getFormat(timeStyleShort: false)
        self.currentDateAndTimeLabel.text = dateFormatter.string(from: date)

        let minMaxTemp = ValueConverter.shared.getTemp(for: forecast.mainTempMin) + "º/" + ValueConverter.shared.getTemp(for: forecast.mainTempMax) + "º"

        self.minMaxTemperetureLabel.text = minMaxTemp
        self.currentTemperetureLabel.text = ValueConverter.shared.getTemp(for: forecast.mainTemp) + "º"
        self.dayForecastLabel.text = forecast.weatherDescription
        self.cloudssunLabel.text = String(forecast.cloudsAll) + "%"
        self.windcolorLabel.text = ValueConverter.shared.getWindSpeed(for: forecast.windSpeed)
        self.rainLabel.text = String(forecast.mainHumidity) + "%"
    }

    /// Задать corDataServise, получить погоду и запросить её установку
    /// - Parameter location: Локация, для которой показываем погоду
    private func setupWeather(for location: Locations) {
        guard let forecast = self.coreDataLocationService?.getObjects()?[0].currentWeather else {return}

        self.setupParametrs(for: forecast)
    }
}

extension CityHeadView: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .update:
            guard let currentWeather = anObject as? LocationsCoreDataModel else {return}
            guard let forecast = currentWeather.currentWeather else {return}
            self.setupParametrs(for: forecast)

        case .insert, .delete, .move:
            return

        @unknown default:
            fatalError()
        }
    }
}
