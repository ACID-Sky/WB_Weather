//
//  CityView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

protocol DiaryViewDelegate: AnyObject {
    func pushMoreInfoController()
}

final class DiaryView: UIView {

    enum Constants {
        static let dateCellID = "DateCellID"
        static let rundownTableViewCellID = "RundownTableViewCellID"
        static let detailedSummaryViewCellID = "DetailedSummaryViewCellID"
        static let sunAndMoonViewCellID = "SunAndMoonViewCellID"
        static let defaultCellID = "DefaultCellID"

        static let cornRadius: CGFloat = 8

        static let numberOfPhoto: CGFloat = 4
        static let nemberOfPhotoCell: CGFloat = 10
        static let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let spacing: CGFloat = 8
    }

    private lazy var label = UILabel()
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var numberOfDaysForecast = 7
    weak var delegate: DiaryViewDelegate?

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
        ])
    }

    private func setupTableView() {
        self.tableView.rowHeight = 44// UITableView.automaticDimension
//        self.tableView.sectionHeaderHeight = 32// UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
//        self.tableView.estimatedSectionHeaderHeight = 40
        self.tableView.register(DateTableViewCell.self, forCellReuseIdentifier: Constants.dateCellID)
        self.tableView.register(RundownTableViewCell.self, forCellReuseIdentifier: Constants.rundownTableViewCellID)
        self.tableView.register(DetailedSummaryViewCell.self, forCellReuseIdentifier: Constants.detailedSummaryViewCellID)
        self.tableView.register(SunAndMoonViewCell.self, forCellReuseIdentifier: Constants.sunAndMoonViewCellID)
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

extension DiaryView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 || section == 2 {
            return 6
        }
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dateCellID, for: indexPath) as? DateTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            return cell
        } else if indexPath == [1,0] || indexPath == [2,0] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rundownTableViewCellID, for: indexPath) as? RundownTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            cell.layer.cornerRadius = Constants.cornRadius
            cell.clipsToBounds = true
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailedSummaryViewCellID, for: indexPath) as? DetailedSummaryViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            cell.layer.cornerRadius = Constants.cornRadius
            cell.clipsToBounds = true
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailedSummaryViewCellID, for: indexPath) as? DetailedSummaryViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            cell.layer.cornerRadius = Constants.cornRadius
            cell.clipsToBounds = true
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sunAndMoonViewCellID, for: indexPath) as? SunAndMoonViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            cell.layer.cornerRadius = Constants.cornRadius
            cell.clipsToBounds = true
            return cell
        }
    }

}

extension DiaryView: UITableViewDelegate {

}

