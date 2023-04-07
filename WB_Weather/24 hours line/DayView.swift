//
//  CityView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

//protocol DayViewDelegate: AnyObject {
//    func pushMoreInfoController()
//}

final class DayView: UIView {

    enum Constants {
        static let dayVisualCellID = "DayVisualCellID"
        static let timeForecastCellID = "TimeForecastCellID"
        static let defaultCellID = "DefaultCellID"

        static let cornRadius: CGFloat = 8

        static let numberOfPhoto: CGFloat = 4
        static let nemberOfPhotoCell: CGFloat = 10
        static let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let spacing: CGFloat = 8
    }

    private lazy var label = UILabel()
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
//    private lazy var numberOfDaysForecast = 7
//    weak var delegate: DayViewDelegate?

    init() {
        super.init(frame: .zero)
        self.setupLabel()
        self.setupTableView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.clipsToBounds = true
        self.label.isUserInteractionEnabled = true
        self.label.text = "City, Country"
        self.label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        self.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.label.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    private func setupTableView() {
        self.tableView.rowHeight = 144// UITableView.automaticDimension
//        self.tableView.sectionHeaderHeight = 32// UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 144
//        self.tableView.estimatedSectionHeaderHeight = 40
        self.tableView.register(DayVisualViewCell.self, forCellReuseIdentifier: Constants.dayVisualCellID)
        self.tableView.register(TimeForecastTableViewCell.self, forCellReuseIdentifier: Constants.timeForecastCellID)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .clear



        self.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
//        self.tableView.tableHeaderView = CityHeadView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 300))
    }


}

extension DayView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 6
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            guard let headrView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.detailsHeadView) as? DetailsHeadView else {
//                return nil
//            }
//            headrView.delegate = self
//            return headrView
//        } else {
//            guard let headrView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.dailyForecastHeadView) as? DailyForecastHeadView else {
//                return nil
//            }
//            return headrView
//        }
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dayVisualCellID, for: indexPath) as? DayVisualViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.timeForecastCellID, for: indexPath) as? TimeForecastTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
//            cell.layer.cornerRadius = Constants.cornRadius
//            cell.clipsToBounds = true
            return cell
        }
    }

}

extension DayView: UITableViewDelegate {

}

