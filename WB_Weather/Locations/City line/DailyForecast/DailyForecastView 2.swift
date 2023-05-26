//
//  DailyForecastTableViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit
import CoreData

protocol DailyForecastViewDelegate: AnyObject {
    func openDiaryViewController(dayIndex: Int)
}

final class DailyForecastView: UIView {
    enum Constants {
        static let dailyForecastCollectionViewCell = "DailyForecastCollectionViewCell"
        static let defaultCellID = "DefaultCellID"

        static let inset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        static let spacing: CGFloat = 10
    }

    var location: Locations
    private lazy var forecasts: [WeatherForecastCoreDataModel] = []
    private lazy var coreDataWeatherService: CoreDataWeatherService = CoreDataWeatherServiceImp(delegate: self, locationID: location.id)
    var numberOfDaysInForecast = 7 {
        didSet {
            self.collectionView.reloadData()
        }
      }
    weak var delegate: DailyForecastViewDelegate?
    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: self.layout)

    init(location: Locations) {
        self.location = location
        super.init(frame: .zero)
        self.setupForecasts()
        self.setupLayout()
        self.setupCollectionView()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Т.К. прогноз для ячейки собирается из нескольких прогнозов, то функция записывает прогносы в класс
    private func setupForecasts() {
        guard let forecasts = self.coreDataWeatherService.getObjects() else {return}
        self.forecasts = forecasts
    }

    private func setupLayout() {
        self.layout.scrollDirection = .vertical
        self.layout.minimumInteritemSpacing = Constants.spacing
    }

    private func setupCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellID)
        self.collectionView.register(DailyForecastCollectionViewCell.self, forCellWithReuseIdentifier: Constants.dailyForecastCollectionViewCell)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false

        self.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

        ])
    }


}
extension DailyForecastView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfDaysInForecast
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dailyForecastCollectionViewCell, for: indexPath) as? DailyForecastCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
            return cell
        }
        let dayForecast = CommonFunctions().getFindDayForecasts(
            for: self.forecasts,
            dayIndex: indexPath.row,
            partOfDay: .allDay,
            dateFormat: "dd/MM"
        )

        cell.setup(for: dayForecast)
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
}

extension DailyForecastView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width
        let itemHeight = 56 * width/344

        return CGSize(width: width, height: itemHeight)
    }

}

extension DailyForecastView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.openDiaryViewController(dayIndex: indexPath.row)
    }
}

extension DailyForecastView: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert, .update:
            self.setupForecasts()
            self.collectionView.reloadData()

        case .delete, .move:
            return

        @unknown default:
            fatalError()
        }
    }
}

