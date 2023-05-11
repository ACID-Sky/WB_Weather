//
//  SettingsViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import UIKit


final class SettingsViewController: UIViewController {

    private lazy var settingsView = SettingsView()
    weak var delegate: LocationWeatherViewControllerDelegete?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupCloudsImageView()
        self.setupSettingsView()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        self.delegate?.changeIsHidePageController(to: false)
    }


    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
    }

    private func setupCloudsImageView() {
        let cloudsImages: [UIImage] = [
            UIImage(named: "backgroundclouds1")!,
            UIImage(named: "backgroundclouds2")!,
            UIImage(named: "backgroundclouds3")!
        ]

        var cloudsImageViews: [UIImageView] = []

        for image in cloudsImages {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = image
            imageView.backgroundColor = .clear
            
            if image == cloudsImages[0] {
                imageView.alpha = 0.3
            }

            cloudsImageViews.append(imageView)
            self.view.addSubview(imageView)

        }
        NSLayoutConstraint.activate([
            cloudsImageViews[0].topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 37),
            cloudsImageViews[0].leadingAnchor.constraint(equalTo: self.view.leadingAnchor),

            cloudsImageViews[1].topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 121),
            cloudsImageViews[1].leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 196),
            cloudsImageViews[1].trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            cloudsImageViews[2].leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 79),
            cloudsImageViews[2].trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -79),
            cloudsImageViews[2].bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -95),
        ])
    }

    private func setupSettingsView() {
        self.settingsView.translatesAutoresizingMaskIntoConstraints = false
        self.settingsView.delegate = self
        self.settingsView.layer.cornerRadius = 8
        self.settingsView.clipsToBounds = true

        self.view.addSubview(self.settingsView)

        NSLayoutConstraint.activate([
            self.settingsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.settingsView.heightAnchor.constraint(equalToConstant: 320),
            self.settingsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28),
            self.settingsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -27),
        ])
    }
}


extension SettingsViewController: SettingsViewDelegate {
    func dismissController() {
        dismiss(animated: true)
    }


}


