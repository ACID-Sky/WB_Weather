//
//  CityDayTimeViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

final class CityDayTimeViewCell: UITableViewCell {

    enum Constants {
        static let shortDayInfoCollectionViewCellID = "ShortDayInfoCollectionViewCellID"
        static let defaultCellID = "DefaultCellID"

        static let numberOfShowTime: CGFloat = 7
        static let nemberOfTimeCell: CGFloat = 24
        static let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let spacing: CGFloat = 8
    }

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
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellID)
        self.collectionView.register(ShortDayInfoCollectionViewCell.self, forCellWithReuseIdentifier: Constants.shortDayInfoCollectionViewCellID)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .clear
//        self.contentView.backgroundColor = .white

        self.contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 60)

        ])
    }

}

extension CityDayTimeViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(Constants.nemberOfTimeCell)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        for (index, toDay) in toDay.enumerated() where indexPath.item == index {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shortDayInfoCollectionViewCellID, for: indexPath) as? ShortDayInfoCollectionViewCell else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
                    return cell
                }
                cell.setup(with: toDay)
                cell.backgroundColor = .systemBackground
                cell.layer.cornerRadius = 20
                cell.clipsToBounds = true
                return cell
            }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
        return cell
        }
}

extension CityDayTimeViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - Constants.spacing * (Constants.numberOfShowTime - 1)
        let itemWidth = floor(width / Constants.numberOfShowTime)
        return CGSize(width: itemWidth, height: itemWidth)
    }

}
