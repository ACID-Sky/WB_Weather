//
//  CityViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit
import CoreData

final class DiaryViewController: UIViewController {

    enum Constants {
        static let dateCellID = "DateCellID"
        static let rundownTableViewCellID = "RundownTableViewCellID"
        static let defaultCellID = "DefaultCellID"
    }

    private lazy var coreDataWeatherService: CoreDataWeatherService = CoreDataWeatherServiceImp(
        delegate: self,
        locationID: self.location.id
    )
    private lazy var forecasts: [WeatherForecastCoreDataModel] = []
    private var location: Locations
    private var dayIndex: Int

    private lazy var label = UILabel()
    private lazy var rootView = UIView()
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var numberOfDaysForecast = 7

    init(location: Locations, dayIndex: Int){
        self.location = location
        self.dayIndex = dayIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupLabel()
        self.setupTableView()
        self.setupForecasts()
    }

    private func setupView() {
        self.navigationItem.title = "DiaryViewController.navigationItem.title".localized
        self.view = BackgroundView(frame: self.view.frame)
        self.rootView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.backgroundColor = .clear
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
        self.label.textColor = UIColor(named: "textColor")

        self.rootView.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.rootView.safeAreaLayoutGuide.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.rootView.leadingAnchor, constant: 16),
            self.label.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.register(DateTableViewCell.self, forCellReuseIdentifier: Constants.dateCellID)
        self.tableView.register(RundownTableViewCell.self, forCellReuseIdentifier: Constants.rundownTableViewCellID)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false



        self.rootView.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.rootView.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.rootView.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
        ])
    }

    /// Т.К. прогноз для ячейки собирается из нескольких прогнозов, то функция записывает прогносы в класс
    private func setupForecasts() {
        guard let forecasts = self.coreDataWeatherService.getObjects() else {return}
        self.forecasts = forecasts
    }
}

extension DiaryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dateCellID, for: indexPath) as? DateTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            cell.delegate = self
            cell.setup(for: self.forecasts, select: self.dayIndex)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rundownTableViewCellID, for: indexPath) as? RundownTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            let timeOfDay: PartOfDay = {
                if indexPath == [1,0] {
                    return .day
                }
                return .night
            }()

            let dayForecast = CommonFunctions().getFindDayForecasts(
                for: self.forecasts,
                dayIndex: self.dayIndex,
                partOfDay: timeOfDay,
                dateFormat: "dd/MM E"
            )

            cell.setupForecast(with: dayForecast)
            cell.clipsToBounds = true
            return cell
        }
    }

}

extension DiaryViewController: DateTableViewCellDelegate {
    func changeDayIndex(to index: Int) {
        let side: UITableView.RowAnimation = {
            if self.dayIndex < index {
                return .left
            } else if self.dayIndex > index {
                return .right
            } else {
                return .none
            }
        }()
        self.dayIndex = index
        let itemsIndex: [IndexPath] = [
        IndexPath(row: 0, section: 1),
        IndexPath(row: 1, section: 1),
        IndexPath(row: 0, section: 2),
        IndexPath(row: 1, section: 2),
        IndexPath(row: 0, section: 3)
        ]

        self.tableView.reloadRows(at: itemsIndex, with: side)
    }
}

extension DiaryViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert, .update:
            self.setupForecasts()
            self.tableView.reloadData()

        case .delete, .move:
            return

        @unknown default:
            fatalError()
        }
    }
}
