//
//  SettingsViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import UIKit


final class SettingsViewController: UIViewController {

    private lazy var settingsView = SettingsView()

    override func loadView() {
        super.loadView()
        self.settingsView.delegate = self
        self.view = settingsView
        self.setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
//        self.view.backgroundColor = .systemBackground
    }
}

extension SettingsViewController: SettingsViewDelegate {
    func dismissController() {
        dismiss(animated: true)
    }
}
