//
//  SwitcherButton.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 08.05.2023.
//

import Foundation
import UIKit

final class SwitcherButton: UIView {

    enum SelectedButton {
        case firstButton
        case secondButton
    }

    private lazy var firstButton = UIButton()
    private lazy var secondButton = UIButton()
    var selectedFirstPosition: Bool

    init(firstPositionName: String, secondPositionName: String, selectedFirstPosition: Bool) {
        self.selectedFirstPosition = selectedFirstPosition
        super.init(frame: .zero)
        self.setupView()
        self.setupFirstButton(with: firstPositionName)
        self.setupSecondButton(with: secondPositionName)
        self.setupPossition()
        self.setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
    private func setupFirstButton(with name: String) {
        self.firstButton.translatesAutoresizingMaskIntoConstraints = false
        self.firstButton.isEnabled = false
        self.firstButton.setTitle(name, for: .normal)

        self.addSubview(self.firstButton)

        NSLayoutConstraint.activate([
            self.firstButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.firstButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.firstButton.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            self.firstButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

    }

    private func setupSecondButton(with name: String) {
        self.secondButton.translatesAutoresizingMaskIntoConstraints = false
        self.secondButton.isEnabled = false
        self.secondButton.setTitle(name, for: .normal)

        self.addSubview(self.secondButton)

        NSLayoutConstraint.activate([
            self.secondButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.secondButton.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            self.secondButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.secondButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupPossition() {
        if self.selectedFirstPosition {
            self.firstButton.backgroundColor = UIColor(named: "buttonBackgroundColor")
            self.firstButton.setTitleColor(UIColor(named: "buttonTextColor"), for: .normal)
            self.secondButton.backgroundColor = UIColor(named: "secondButtonBackground")
            self.secondButton.setTitleColor(UIColor(named: "secontButtonText"), for: .normal)
        } else {
            self.firstButton.backgroundColor = UIColor(named: "secondButtonBackground")
            self.firstButton.setTitleColor(UIColor(named: "secontButtonText"), for: .normal)
            self.secondButton.backgroundColor = UIColor(named: "buttonBackgroundColor")
            self.secondButton.setTitleColor(UIColor(named: "buttonTextColor"), for: .normal)
        }
    }

    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer){
        if self.selectedFirstPosition {
            self.selectedFirstPosition = false
        } else {
            self.selectedFirstPosition = true
        }
        self.setupPossition()

    }
}
