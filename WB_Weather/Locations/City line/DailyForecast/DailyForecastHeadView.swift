//
//  DailyForecastHeadView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

protocol DailyForecastHeadViewDelegate: AnyObject {
    func changeCountOfDays()
}

final class DailyForecastHeadView: UIView {

    private lazy var label = UILabel()
    private lazy var daysLabel = UILabel()
    weak var delegate: DailyForecastHeadViewDelegate?

    init(){
        super.init(frame: .zero)
        self.setupLabel()
        self.setupDaysLabel()
        self.setupGestures()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupLabel() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.clipsToBounds = true
        self.label.isUserInteractionEnabled = true
        self.label.text = "DailyForecastHeadView.label.text".localized
        self.label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        self.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupDaysLabel() {
        self.daysLabel.translatesAutoresizingMaskIntoConstraints = false
        self.daysLabel.clipsToBounds = true
        self.daysLabel.isUserInteractionEnabled = true
        self.daysLabel.text = "25" + "days".localized
        self.daysLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        self.addSubview(self.daysLabel)

        NSLayoutConstraint.activate([
            self.daysLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.daysLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.daysLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.daysLabel.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.changeCountOfDays()
    }

}

extension DailyForecastHeadView {
    func setupDays(count: Int) {
        self.daysLabel.text = String(count) + "days".localized
    }
}
