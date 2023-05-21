//
//  SettinsView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 07.05.2023.
//

import UIKit
protocol SettingsViewDelegate: AnyObject {
    func dismissController()
}

class SettingsView: UIView {

    private lazy var mainLabel = UILabel()
    private lazy var verticalStackView = UIStackView()
    private let userDefaults = UserDefaults.standard

    private var temperatureInFahrenheit: SwitcherButton?
    private var windSpeedInMi: SwitcherButton?
    private var timeFormat12: SwitcherButton?
    private var noticeOn: SwitcherButton?

    private lazy var button = UIButton()
    weak var delegate: SettingsViewDelegate?

    init() {
        super.init(frame: .zero)
        self.backgroundColor = Palette.cellBackgroundColor
        self.setupMainLabel()
        self.setupVerticalStack()
        self.setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMainLabel() {
        self.mainLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainLabel.clipsToBounds = true
        self.mainLabel.textColor = Palette.cellTextColor
        self.mainLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.mainLabel.textAlignment = .left
        self.mainLabel.text = "SettingsView.mainLabel.text".localized

        self.addSubview(self.mainLabel)

        NSLayoutConstraint.activate([
            self.mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            self.mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        ])

    }

    private func setupVerticalStack() {

        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verticalStackView.axis = .vertical
        self.verticalStackView.spacing = 4
        self.verticalStackView.distribution = .fillEqually
        self.verticalStackView.alignment = .fill

        self.addSubview(self.verticalStackView)

        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: 20),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -93),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
        ])

        self.setupParams()
    }

    private func setupParams() {
        let temperatureInFahrenheit = userDefaults.bool(forKey: "temperatureInFahrenheit")
        let windSpeedInMi = userDefaults.bool(forKey: "windSpeedInMi")
        let timeFormat12 = userDefaults.bool(forKey: "timeFormat12")
        let noticeOn = userDefaults.bool(forKey: "noticeOn")

        self.temperatureInFahrenheit = SwitcherButton(
            firstPositionName: "SettingsView.temperatureInFahrenheit.first".localized,
            secondPositionName: "SettingsView.temperatureInFahrenheit.second".localized,
            selectedFirstPosition: temperatureInFahrenheit
        )
        self.windSpeedInMi = SwitcherButton(
            firstPositionName: "SettingsView.windSpeedInMi.first".localized,
            secondPositionName: "SettingsView.windSpeedInMi.second".localized,
            selectedFirstPosition: windSpeedInMi
        )
        self.timeFormat12 = SwitcherButton(
            firstPositionName: "12",
            secondPositionName: "24",
            selectedFirstPosition: timeFormat12
        )
        self.noticeOn = SwitcherButton(
            firstPositionName: "SettingsView.noticeOn.first".localized,
            secondPositionName: "SettingsView.noticeOn.second".localized,
            selectedFirstPosition: noticeOn
        )

        self.setupParam(with: "SettingsView.temperature".localized, switcher: self.temperatureInFahrenheit)
        self.setupParam(with: "SettingsView.windSpeed".localized, switcher: self.windSpeedInMi)
        self.setupParam(with: "SettingsView.timeFormat".localized, switcher: self.timeFormat12)
        self.setupParam(with: "SettingsView.notifications".localized, switcher: self.noticeOn)
    }

    private func setupParam(with text: String, switcher: SwitcherButton?){
        let paramsHorizontalStack = UIStackView()
        paramsHorizontalStack.axis = .horizontal
        paramsHorizontalStack.spacing = 8
        paramsHorizontalStack.distribution = .fillEqually
        paramsHorizontalStack.alignment = .fill



        let label = UILabel()
        label.clipsToBounds = true
        label.textColor = Palette.cellTextColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.text = text

        paramsHorizontalStack.addArrangedSubview(label)
        if switcher != nil {
            paramsHorizontalStack.addArrangedSubview(switcher!)
        }
        self.verticalStackView.addArrangedSubview(paramsHorizontalStack)
    }

    private func setupButton() {

        self.button.setTitle("SettingsView.button.title".localized, for: .normal)
        self.button.setTitleColor(.white, for: .normal)
        self.button.backgroundColor = Palette.buttonBackgroundColor
        self.button.setTitleColor(Palette.buttonTextColor, for: .normal)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTarget(self, action:  #selector(buttonTapped), for: .touchUpInside)

        self.addSubview(self.button)

        NSLayoutConstraint.activate([
            self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.button.heightAnchor.constraint(equalToConstant: 40),
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35),
        ])

        self.button.layer.cornerRadius = 10
    }

    @objc private func buttonTapped () {
        if self.temperatureInFahrenheit?.selectedFirstPosition !=  self.userDefaults.bool(forKey: "temperatureInFahrenheit") {
            self.userDefaults.setValue(self.temperatureInFahrenheit?.selectedFirstPosition, forKey: "temperatureInFahrenheit")
        }

        if self.windSpeedInMi?.selectedFirstPosition !=  self.userDefaults.bool(forKey: "windSpeedInMi") {
            self.userDefaults.setValue(self.windSpeedInMi?.selectedFirstPosition, forKey: "windSpeedInMi")
        }
        if self.timeFormat12?.selectedFirstPosition !=  self.userDefaults.bool(forKey: "timeFormat12") {
            self.userDefaults.setValue(self.timeFormat12?.selectedFirstPosition, forKey: "timeFormat12")
        }
        if self.noticeOn?.selectedFirstPosition !=  self.userDefaults.bool(forKey: "noticeOn") {
            self.userDefaults.setValue(self.noticeOn?.selectedFirstPosition, forKey: "noticeOn")
        }

        delegate?.dismissController()

    }
}
