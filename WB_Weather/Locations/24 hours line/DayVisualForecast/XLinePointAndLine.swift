//
//  XLinePointAndLine.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 03.05.2023.
//

import UIKit

class XLinePointAndLine: UIView {

let point = UIView()
let line = UIView()

    init() {
        super.init(frame: .zero)
        self.setupComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponents() {
        self.point.backgroundColor =  Palette.cellTextColor
        self.point.translatesAutoresizingMaskIntoConstraints = false
        self.line.backgroundColor =  Palette.cellTextColor
        self.line.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.point)
        self.addSubview(self.line)

        NSLayoutConstraint.activate([
            self.point.topAnchor.constraint(equalTo: self.topAnchor),
            self.point.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),

            self.point.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.point.widthAnchor.constraint(equalToConstant: 4),
            self.point.heightAnchor.constraint(equalToConstant: 8),

            self.line.leadingAnchor.constraint(equalTo: self.point.trailingAnchor),
            self.line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.line.topAnchor.constraint(equalTo: self.point.centerYAnchor),
            self.line.heightAnchor.constraint(equalToConstant: 1),
            self.line.widthAnchor.constraint(equalToConstant: 51)
        ])
    }
}
