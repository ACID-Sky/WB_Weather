//
//  CityViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit
import CoreData

final class DayViewController: UIViewController {
    enum Constants {
        static let dayVisualCellID = "DayVisualCellID"
        static let timeForecastCellID = "TimeForecastCellID"
        static let defaultCellID = "DefaultCellID"
    }

    private var location: Locations
    private var coreDataWeatherService: CoreDataWeatherService?
    private lazy var rootView = UIView()
    private lazy var label = UILabel()
    private lazy var dayVisualView = DayVisualView()
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)

    init(for location: Locations){
        self.location = location
        let date = Date()
        super.init(nibName: nil, bundle: nil)
        self.coreDataWeatherService = CoreDataWeatherServiceImp(delegate: self, locationID: location.id, date: date)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupLabel()
        self.setupDayVisualView()
        self.setupTableView()
    }

    private func setupView() {
        self.navigationItem.title = "DayViewController.navigationItem.title".localized
        self.view.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        self.rootView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.backgroundColor = .systemBackground
        self.view.addSubview(rootView)

        NSLayoutConstraint.activate([
            self.rootView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.rootView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.rootView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupLabel() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.clipsToBounds = true
        self.label.isUserInteractionEnabled = true
        self.label.text = self.location.locationName
        self.label.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        self.rootView.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.rootView.safeAreaLayoutGuide.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.rootView.leadingAnchor, constant: 16),
            self.label.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    private func setupDayVisualView(){
        self.dayVisualView.translatesAutoresizingMaskIntoConstraints = false

        self.rootView.addSubview(self.dayVisualView)

        NSLayoutConstraint.activate([
            self.dayVisualView.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            self.dayVisualView.leadingAnchor.constraint(equalTo: self.rootView.leadingAnchor),
            self.dayVisualView.trailingAnchor.constraint(equalTo: self.rootView.trailingAnchor),
            self.dayVisualView.heightAnchor.constraint(equalToConstant: 165),
        ])

        self.setupDayVisualViewInfo()
    }

    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.register(TimeForecastTableViewCell.self, forCellReuseIdentifier: Constants.timeForecastCellID)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false

        self.rootView.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.dayVisualView.bottomAnchor, constant: 4),
            self.tableView.leadingAnchor.constraint(equalTo: self.rootView.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.rootView.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
        ])
    }

    private func setupDayVisualViewInfo() {
        guard let forecasts = self.coreDataWeatherService?.getObjects() else {return}
        self.dayVisualView.setupWeather(for: forecasts)
    }

}


extension DayViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = self.coreDataWeatherService?.getNubers(section: 0) else { return 0 }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.timeForecastCellID, for: indexPath) as? TimeForecastTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
            return cell
        }

        guard let weatherForecastModel = self.coreDataWeatherService?.getObject(index: indexPath) else { return cell}
        cell.setupWeather(for: weatherForecastModel, index: indexPath)
        return cell

    }

}

extension DayViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }

            self.tableView.insertRows(at: [newIndexPath], with: .left)
        case .delete:
            guard let indexPath = indexPath else { return }

            self.tableView.deleteRows(at: [indexPath], with: .right)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }

            self.tableView.deleteRows(at: [indexPath], with: .right)
            self.tableView.insertRows(at: [newIndexPath], with: .left)
        case .update:
            guard let indexPath = indexPath else { return }

            self.tableView.reloadRows(at: [indexPath], with: .fade)

        @unknown default:
            fatalError()
        }
    }
}
