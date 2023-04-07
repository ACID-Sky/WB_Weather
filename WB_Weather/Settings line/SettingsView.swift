//
//  SettingsView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {
    func dismissController()
}

final class SettingsView: UIView {

    enum Constants {
        static let settingCellID = "SettingCellID"
        static let buttonCellID = "ButtonCellID"
        static let defaultCellID = "DefaultCellID"
    }

    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    weak var delegate: SettingsViewDelegate?

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .darkGray
        self.setupTableView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
//        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 32
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: Constants.settingCellID)
        self.tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: Constants.buttonCellID)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false

        self.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.tableView.heightAnchor.constraint(equalToConstant: 320),
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }


}

extension SettingsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            cell.textLabel?.text = "Settings"
            return cell
        } else if indexPath == [0,5] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.buttonCellID, for: indexPath) as? ButtonTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.settingCellID, for: indexPath) as? SettingsTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            return cell
        }
    }

}

extension SettingsView: ButtonTableViewCellDelegate {
    func dismissController() {
        self.delegate?.dismissController()
    }


}


