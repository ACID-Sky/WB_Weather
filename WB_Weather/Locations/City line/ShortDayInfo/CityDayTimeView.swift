//
//  CityDayTimeViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit
import CoreData

final class CityDayTimeView: UIView {
    enum Constants {
        static let shortDayInfoCollectionViewCellID = "ShortDayInfoCollectionViewCellID"
        static let defaultCellID = "DefaultCellID"

        static let numberOfShowTime: CGFloat = 6
        static let spacing: CGFloat = 8
    }

    var coreDataWeatherService: CoreDataWeatherService?

    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: self.layout)

    init(location: Locations){
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.coreDataWeatherService = CoreDataWeatherServiceImp(delegate: self, locationID: location.id)
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
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellID)
        self.collectionView.register(ShortDayInfoCollectionViewCell.self, forCellWithReuseIdentifier: Constants.shortDayInfoCollectionViewCellID)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .clear

        self.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

}

extension CityDayTimeView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItems = self.coreDataWeatherService?.getNubers(section: section)
        else { return 0 }
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shortDayInfoCollectionViewCellID, for: indexPath) as? ShortDayInfoCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
            return cell
        }
        guard let weatherForecastModel = self.coreDataWeatherService?.getObject(index: indexPath) else { return cell}

        cell.setup(with: weatherForecastModel)
        let width = collectionView.frame.width - Constants.spacing * (Constants.numberOfShowTime - 1)
        let itemWidth = width / Constants.numberOfShowTime
        cell.layer.cornerRadius = itemWidth/2
        cell.layer.borderColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        cell.layer.borderWidth = 0.5
        cell.clipsToBounds = true
        return cell
    }
}

extension CityDayTimeView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - Constants.spacing * (Constants.numberOfShowTime - 1)
        let itemWidth = floor(width / Constants.numberOfShowTime)
        let itemHeight = floor(80 * collectionView.frame.width/344)
        return CGSize(width: itemWidth, height: itemHeight)
    }

}

extension CityDayTimeView: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            self.collectionView.reloadData()

        case .update, .delete, .move:
            return

        @unknown default:
            fatalError()
        }
    }
}
