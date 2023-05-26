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
        self.firstButton.setTitleColor(.black, for: .normal)

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
        self.secondButton.setTitleColor(.black, for: .normal)

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
            self.firstButton.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
            self.secondButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            self.firstButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.secondButton.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
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
