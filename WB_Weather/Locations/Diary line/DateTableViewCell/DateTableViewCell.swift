//
//  DateTableViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import UIKit

protocol DateTableViewCellDelegate: AnyObject {
    func changeDayIndex(to index: Int)
}

final class DateTableViewCell: UITableViewCell {
    enum Constants {
        static let dayForCellID = "DayForCellID"
        static let defaultCellID = "DefaultCellID"

        static let numberOfShowTime: CGFloat = 4
        static let numberOfDayCell: CGFloat = 25
        static let spacing: CGFloat = 8
    }

    var delegate: DateTableViewCellDelegate?
    private lazy var forecasts: [WeatherForecastCoreDataModel] = []
    private lazy var dayIndex: Int = 0
    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: self.layout)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.setupLayout()
        self.setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.layout.scrollDirection = .horizontal
        self.layout.minimumInteritemSpacing = Constants.spacing
    }

    private func setupCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellID)
        self.collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: Constants.dayForCellID)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}

extension DateTableViewCell {
    /// Передача массива прогнозов и выбранного дня в класс ячейки, для отображения информации
    /// - Parameters:
    ///   - forecasts: Массив прогнозов по локации
    ///   - idexDay: индекс дня, который должен быть выбран при загрузке
    func setup(for forecasts: [WeatherForecastCoreDataModel], select idexDay: Int) {
        self.forecasts = forecasts
        self.dayIndex = idexDay
        self.setupLayout()
        self.setupCollectionView()
    }
}

extension DateTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(Constants.numberOfDayCell)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dayForCellID, for: indexPath) as? DateCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
            return cell
        }

        let dayForecast = CommonFunctions().getFindDayForecasts(
            for: self.forecasts,
            dayIndex: indexPath.row,
            partOfDay: .allDay,
            dateFormat: "dd/MM E"
        )
        let backGround = {
            if self.dayIndex == indexPath.row {
                return #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
            } else {
                return .clear
            }
        }()

        cell.setup(with: dayForecast.dateText, bgColor: backGround )
            cell.layer.cornerRadius = 6
            cell.clipsToBounds = true
            return cell
        }
}

extension DateTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - Constants.spacing * (Constants.numberOfShowTime - 1)
        let itemWidth = floor(width / Constants.numberOfShowTime)
        let itemHeight = floor(30 * itemWidth/76)
        return CGSize(width: itemWidth, height: itemHeight)
    }

}

extension DateTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastSelectCell = IndexPath(row: self.dayIndex, section: indexPath.section)
        self.dayIndex = indexPath.row
        self.collectionView.reloadItems(at: [lastSelectCell, indexPath])
        self.delegate?.changeDayIndex(to: indexPath.row)
    }

}

