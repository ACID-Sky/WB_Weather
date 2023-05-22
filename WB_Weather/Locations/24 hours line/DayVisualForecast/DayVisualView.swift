//
//  CityDayTimeViewCell.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

final class DayVisualView: UIView {

    private lazy var grathScrollView = UIScrollView()
    private var grathView = DayGraphView()
    private lazy var xLineDayViews: [XLineDayVisualView] = []

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "cellBackgroundColor")
        self.setupGrathScrollView()
    }


    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGrathScrollView(){
        self.grathScrollView.isPagingEnabled = true
        self.grathScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.grathScrollView.showsHorizontalScrollIndicator = false

        self.addSubview(self.grathScrollView)

        NSLayoutConstraint.activate([
            self.grathScrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.grathScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.grathScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.grathScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])

    }

    private func setupGrathView(for forecast: [WeatherForecastCoreDataModel]) {

        self.grathView.translatesAutoresizingMaskIntoConstraints = false

        self.grathScrollView.addSubview(self.grathView)

        NSLayoutConstraint.activate([
            self.grathView.topAnchor.constraint(equalTo: self.grathScrollView.topAnchor),
            self.grathView.leadingAnchor.constraint(equalTo: self.grathScrollView.leadingAnchor),
            self.grathView.trailingAnchor.constraint(equalTo: self.grathScrollView.trailingAnchor),
            self.grathView.heightAnchor.constraint(equalToConstant: 60),
        ])

        self.grathView.setupPoints(for: forecast, heignt:  60)
    }

    private func viewsConstraints() ->  [NSLayoutConstraint] {
        var viewsConstraints: [NSLayoutConstraint] = []

        for (index, xLineDayView) in self.xLineDayViews.enumerated() {
            let topAnchor = xLineDayView.topAnchor.constraint(equalTo: self.grathView.bottomAnchor, constant: 8)
            let widthAnchor = xLineDayView.widthAnchor.constraint(equalToConstant: 75)
            let heightAnchor = xLineDayView.heightAnchor.constraint(equalToConstant: 82)
            viewsConstraints.append(topAnchor)
            viewsConstraints.append(widthAnchor)
            viewsConstraints.append(heightAnchor)

            if index == 0 {
                let leadingAnchor = xLineDayView.leadingAnchor.constraint(equalTo: self.grathScrollView.leadingAnchor)
                let trailingAnchor = xLineDayView.trailingAnchor.constraint(equalTo: self.xLineDayViews[index + 1].leadingAnchor)
                viewsConstraints.append(leadingAnchor)
                viewsConstraints.append(trailingAnchor)
                continue
            }

            if index == self.xLineDayViews.count - 1 {
                let leadingAnchor = xLineDayView.leadingAnchor.constraint(equalTo: self.xLineDayViews[index - 1].trailingAnchor)
                let trailingAnchor = xLineDayView.trailingAnchor.constraint(equalTo: self.grathScrollView.trailingAnchor, constant: 20)
                viewsConstraints.append(leadingAnchor)
                viewsConstraints.append(trailingAnchor)
                continue
            }

            let leadingAnchor = xLineDayView.leadingAnchor.constraint(equalTo: self.xLineDayViews[index - 1].trailingAnchor)
            let trailingAnchor = xLineDayView.trailingAnchor.constraint(equalTo: self.xLineDayViews[index + 1].leadingAnchor)
            viewsConstraints.append(leadingAnchor)
            viewsConstraints.append(trailingAnchor)
        }

        return viewsConstraints
    }
}

extension DayVisualView {
    func setupWeather(for forecast: [WeatherForecastCoreDataModel]) {

        self.grathScrollView.subviews.forEach({ $0.removeFromSuperview() })

        self.setupGrathView(for: forecast)

        forecast.forEach({
            let view = XLineDayVisualView(with: $0)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.xLineDayViews.append(view)
            self.grathScrollView.addSubview(view)

        })

        let viewsConstraints = self.viewsConstraints()

        NSLayoutConstraint.activate(viewsConstraints)
    }
}
