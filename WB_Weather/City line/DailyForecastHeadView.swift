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

final class DailyForecastHeadView: UITableViewHeaderFooterView {

    private lazy var label = UILabel()
    private lazy var daysLabel = UILabel()
    weak var delegate: DailyForecastHeadViewDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        self.label.text = "Daily forecast"
        self.label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        self.contentView.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    private func setupDaysLabel() {
        self.daysLabel.translatesAutoresizingMaskIntoConstraints = false
        self.daysLabel.clipsToBounds = true
        self.daysLabel.isUserInteractionEnabled = true
        self.daysLabel.text = "7 days"
        self.daysLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        self.contentView.addSubview(self.daysLabel)

        NSLayoutConstraint.activate([
            self.daysLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.daysLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.daysLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.daysLabel.addGestureRecognizer(tapGestureRecognizer)

    }
    func setupDays(count: Int) {
        self.daysLabel.text = String(count) + " days"
    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.changeCountOfDays()
    }

}
