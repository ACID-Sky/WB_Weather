//
//  AutorizationViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 07.04.2023.
//

import UIKit

protocol AutorizationViewControllerDelegate: AnyObject {
    func openAuthorizationView()
    func refusalToUseLocation()
}

final class AutorizationViewController: UIViewController {

    weak var delegate: AutorizationViewControllerDelegate?
    private lazy var image = UIImageView()
    private lazy var fistlabel = UILabel()
    private lazy var secondLabel = UILabel()
    private lazy var acceptButton = UIButton()
    private lazy var refusalLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        self.setupImage()
        self.setupFirstLabel()
        self.setupSecondLabel()
        self.setupAcceptButton()
        self.setupRefusalLabel()
        self.setupGestures()

    }

    private func setupImage() {
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.image.clipsToBounds = true
        self.image.isUserInteractionEnabled = true
        self.image.image = UIImage(named: "woman") ?? UIImage(systemName: "cloud.fill")
        self.image.contentMode = .center

        self.view.addSubview(self.image)

        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.image.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 80),
            self.image.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.image.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
        ])
    }

    private func setupFirstLabel() {
        self.fistlabel.translatesAutoresizingMaskIntoConstraints = false
        self.fistlabel.clipsToBounds = true
        self.fistlabel.isUserInteractionEnabled = true
        self.fistlabel.numberOfLines = 0
        self.fistlabel.text = "AutorizationViewController.fistlabel.text".localized
        self.fistlabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        self.view.addSubview(self.fistlabel)

        NSLayoutConstraint.activate([
            self.fistlabel.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 16),
            self.fistlabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            self.fistlabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.fistlabel.heightAnchor.constraint(equalToConstant: 80),
        ])
    }

    private func setupSecondLabel() {
        self.secondLabel.translatesAutoresizingMaskIntoConstraints = false
        self.secondLabel.clipsToBounds = true
        self.secondLabel.isUserInteractionEnabled = true
        self.secondLabel.numberOfLines = 0
        self.secondLabel.text = "AutorizationViewController.secondLabel.text".localized
        self.secondLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        self.view.addSubview(self.secondLabel)

        NSLayoutConstraint.activate([
            self.secondLabel.topAnchor.constraint(equalTo: self.fistlabel.bottomAnchor, constant: 8),
            self.secondLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            self.secondLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.fistlabel.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    private func setupAcceptButton() {
        let text = "AutorizationViewController.acceptButton.setTitle".localized
        self.acceptButton.setTitle(text, for: .normal)
        self.acceptButton.setTitleColor(.systemBackground, for: .normal)
        self.acceptButton.backgroundColor = .systemOrange
        self.acceptButton.translatesAutoresizingMaskIntoConstraints = false
        self.acceptButton.addTarget(self, action:  #selector(buttonTapped), for: .touchUpInside)

        self.view.addSubview(self.acceptButton)

        NSLayoutConstraint.activate([
            self.acceptButton.topAnchor.constraint(equalTo: self.secondLabel.bottomAnchor, constant: 16),
            self.acceptButton.heightAnchor.constraint(equalToConstant: 40),
            self.acceptButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            self.acceptButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
        ])

        self.acceptButton.layer.cornerRadius = 10
    }

    private func setupRefusalLabel() {
        self.refusalLabel.translatesAutoresizingMaskIntoConstraints = false
        self.refusalLabel.clipsToBounds = true
        self.refusalLabel.isUserInteractionEnabled = true
        self.refusalLabel.text = "AutorizationViewController.refusalLabel.text".localized
        self.refusalLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        self.view.addSubview(self.refusalLabel)

        NSLayoutConstraint.activate([
            self.refusalLabel.topAnchor.constraint(equalTo: self.acceptButton.bottomAnchor, constant: 16),
            self.refusalLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
        ])
    }
    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.refusalLabel.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.refusalToUseLocation()
        self.dismiss(animated: true)
    }



    @objc private func buttonTapped () {
        self.delegate?.openAuthorizationView()
        self.dismiss(animated: true)
    }
}
