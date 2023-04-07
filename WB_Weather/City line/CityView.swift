//
//  CityView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

protocol CityViewDelegate: AnyObject {
    func pushMoreInfoController()
    func pushDiaryController()
}

final class CityView: UIView {

    enum Constants {
//        static let cityHeadView = "CityHeadView"
        static let detailsHeadViewID = "DetailsHeadViewID"
        static let dailyForecastHeadViewID = "DailyForecastHeadViewID"

        static let cityDayTimeCellID = "CityDayTimeCellID"
        static let dailyForecastCellID = "DailyForecastCellID"
        static let defaultCellID = "DefaultCellID"

        static let cornRadius: CGFloat = 8
    }

    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var numberOfDaysForecast = 7
    weak var delegate: CityViewDelegate?

    init() {
        super.init(frame: .zero)
        self.setupTableView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.estimatedSectionHeaderHeight = 30
//        self.tableView.register(CityHeadView.self, forHeaderFooterViewReuseIdentifier: Constants.cityHeadView)
        self.tableView.register(DetailsHeadView.self, forHeaderFooterViewReuseIdentifier: Constants.detailsHeadViewID)
        self.tableView.register(DailyForecastHeadView.self, forHeaderFooterViewReuseIdentifier: Constants.dailyForecastHeadViewID)
        self.tableView.register(CityDayTimeViewCell.self, forCellReuseIdentifier: Constants.cityDayTimeCellID)
        self.tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: Constants.dailyForecastCellID)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.separatorStyle = .singleLine



        self.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        self.tableView.tableHeaderView = CityHeadView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 250))
    }


}

extension CityView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.numberOfDaysForecast
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headrView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.detailsHeadViewID) as? DetailsHeadView else {
                return nil
            }
            headrView.delegate = self
            return headrView
        } else {
            guard let headrView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.dailyForecastHeadViewID) as? DailyForecastHeadView else {
                return nil
            }
            headrView.delegate = self
            headrView.setupDays(count: self.numberOfDaysForecast)
            return headrView
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cityDayTimeCellID, for: indexPath) as? CityDayTimeViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dailyForecastCellID, for: indexPath) as? DailyForecastTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            cell.layer.cornerRadius = Constants.cornRadius
            cell.clipsToBounds = true
            return cell
        }
    }

}

extension CityView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushDiaryController()
    }

}

extension CityView: DetailsHeaderViewDelegate {
    func openMoreInfoView() {
        self.delegate?.pushMoreInfoController()
    }
}

extension CityView: DailyForecastHeadViewDelegate {
    func changeCountOfDays() {
        if self.numberOfDaysForecast == 7 {
            self.numberOfDaysForecast = 25
        } else {
            self.numberOfDaysForecast = 7
        }
        self.tableView.reloadData()
    }

}
