//
//  DateCollectionViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 04.05.2023.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    private lazy var dayLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTimeLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTimeLabel() {
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dayLabel.clipsToBounds = true
        self.dayLabel.isUserInteractionEnabled = true
        self.dayLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        self.contentView.addSubview(self.dayLabel)

        NSLayoutConstraint.activate([
            self.dayLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.dayLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        ])
    }

}

extension DateCollectionViewCell{

    /// Передача даты ячейки и цвета
    /// - Parameters:
    ///   - name: дата ячейки в виде текста
    ///   - bgColor: цвет для фона ячейки
    func setup(with name: String, bgColor: UIColor) {
        self.dayLabel.text = name
        self.backgroundColor = bgColor
    }
}
