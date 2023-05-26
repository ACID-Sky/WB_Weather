//
//  LocationWeatherViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 17.04.2023.
//

import UIKit
//import CoreData

protocol LocationWeatherViewControllerDelegete: AnyObject {
    /// Устанавливаем Title в навигейшен и меняем индекс актуальной страницы у pageController
    /// - Parameters:
    ///   - index: индекс открытой страницы
    ///   - locationName: название для вывода
    func setTitle(for index: Int, equal locationName: String)
    func changeIsHidePageController(to value: Bool)
}

class LocationWeatherViewController: UIViewController {

    var index: Int = 0
    let location: Locations
    let delegate: LocationWeatherViewControllerDelegete

    private lazy var vieForPage = UIView()
    private lazy var cityHeaderView = CityHeadView(location: self.location)
    private lazy var detailsView = DetailsView()
    private lazy var cityDayTimeView = CityDayTimeView(location: self.location)
    private lazy var dailyForecastHeadView = DailyForecastHeadView()
    private lazy var dailyForecastView = DailyForecastView(location: self.location)


    init(for location: Locations, delegate: LocationWeatherViewControllerDelegete) {
        self.delegate = delegate
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewForPage()
        self.setupCityHeadView()
        self.setupDetailsView()
        self.setupCityDayTimeView()
        self.setupDailyForecastHeadView()
        self.setupDailyForecastView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate.setTitle(for: self.index, equal: self.location.locationName)
        self.delegate.changeIsHidePageController(to: false)
    }

    private func setupViewForPage() {
        self.vieForPage.backgroundColor = .systemBackground
        self.vieForPage.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.vieForPage)

        NSLayoutConstraint.activate([
            self.vieForPage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.vieForPage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.vieForPage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.vieForPage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupCityHeadView(){
        self.cityHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.cityHeaderView.layer.cornerRadius = 8
        self.cityHeaderView.clipsToBounds = true
        let weight = self.view.frame.width - 31
        let height = 212 * (weight / 344)

        self.vieForPage.addSubview(self.cityHeaderView)

        NSLayoutConstraint.activate([
            self.cityHeaderView.topAnchor.constraint(equalTo: self.vieForPage.topAnchor, constant: 20),
            self.cityHeaderView.leadingAnchor.constraint(equalTo: self.vieForPage.leadingAnchor, constant: 16),
            self.cityHeaderView.trailingAnchor.constraint(equalTo: self.vieForPage.trailingAnchor, constant: -15),
            self.cityHeaderView.heightAnchor.constraint(equalToConstant: height),
        ])
    }

    private func setupDetailsView(){
        self.detailsView.delegate = self
        self.detailsView.translatesAutoresizingMaskIntoConstraints = false

        self.vieForPage.addSubview(self.detailsView)

        NSLayoutConstraint.activate([
            self.detailsView.topAnchor.constraint(equalTo: self.cityHeaderView.bottomAnchor, constant: 24),
            self.detailsView.leadingAnchor.constraint(equalTo: self.vieForPage.leadingAnchor, constant: 16),
            self.detailsView.trailingAnchor.constraint(equalTo: self.vieForPage.trailingAnchor, constant: -15),
        ])
    }

    private func setupCityDayTimeView(){
        self.cityDayTimeView.translatesAutoresizingMaskIntoConstraints = false

        let weight = self.view.frame.width - 31
        let height = 80 * (weight / 344)

        self.vieForPage.addSubview(self.cityDayTimeView)

        NSLayoutConstraint.activate([
            self.cityDayTimeView.topAnchor.constraint(equalTo: self.detailsView.bottomAnchor, constant: 24),
            self.cityDayTimeView.leadingAnchor.constraint(equalTo: self.vieForPage.leadingAnchor, constant: 16),
            self.cityDayTimeView.trailingAnchor.constraint(equalTo: self.vieForPage.trailingAnchor, constant: -15),
            self.cityDayTimeView.heightAnchor.constraint(equalToConstant: height),
        ])
    }

    private func setupDailyForecastHeadView(){
        self.dailyForecastHeadView.delegate = self
        self.dailyForecastHeadView.translatesAutoresizingMaskIntoConstraints = false

        self.vieForPage.addSubview(self.dailyForecastHeadView)

        NSLayoutConstraint.activate([
            self.dailyForecastHeadView.topAnchor.constraint(equalTo: self.cityDayTimeView.bottomAnchor, constant: 24),
            self.dailyForecastHeadView.leadingAnchor.constraint(equalTo: self.vieForPage.leadingAnchor, constant: 16),
            self.dailyForecastHeadView.trailingAnchor.constraint(equalTo: self.vieForPage.trailingAnchor, constant: -15),
        ])
    }

    private func setupDailyForecastView() {
        self.dailyForecastView.delegate = self
        self.dailyForecastView.translatesAutoresizingMaskIntoConstraints = false

        self.vieForPage.addSubview(self.dailyForecastView)

        NSLayoutConstraint.activate([
            self.dailyForecastView.topAnchor.constraint(equalTo: self.dailyForecastHeadView.bottomAnchor, constant: 24),
            self.dailyForecastView.leadingAnchor.constraint(equalTo: self.vieForPage.leadingAnchor, constant: 16),
            self.dailyForecastView.trailingAnchor.constraint(equalTo: self.vieForPage.trailingAnchor, constant: -15),
            self.dailyForecastView.bottomAnchor.constraint(equalTo: self.vieForPage.bottomAnchor),
        ])
    }
}

extension LocationWeatherViewController: DailyForecastViewDelegate {
    func openDiaryViewController(dayIndex: Int) {
        let vc = DiaryViewController(location: self.location, dayIndex: dayIndex)
        self.navigationController?.pushViewController(vc, animated: true)
        self.delegate.changeIsHidePageController(to: true)
    }
}

extension LocationWeatherViewController: DetailsViewDelegate {
    func openMoreInfoView() {
        let vc = DayViewController(for: self.location)
        self.navigationController?.pushViewController(vc, animated: true)
        self.delegate.changeIsHidePageController(to: true)
    }
}

extension LocationWeatherViewController: DailyForecastHeadViewDelegate {
    func changeCountOfDays() {
        if self.dailyForecastView.numberOfDaysInForecast == 7 {
            self.dailyForecastHeadView.setupDays(count: 7)
            self.dailyForecastView.numberOfDaysInForecast = 25
        } else {
            self.dailyForecastHeadView.setupDays(count: 25)
            self.dailyForecastView.numberOfDaysInForecast = 7
        }
    }

}
