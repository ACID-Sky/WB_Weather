//
//  DayGraphView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 02.05.2023.
//

import UIKit

final class DayGraphView: UIView {

    private lazy var stackView = UIStackView()

    init() {
        super.init(frame: .zero)
        self.setupStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    private func setupStackView(){
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .horizontal
        self.stackView.spacing = 0
        self.stackView.distribution = .fillEqually
        self.stackView.alignment = .fill

        self.addSubview(self.stackView)

        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

extension DayGraphView {
    func setupPoints(for forecast: [WeatherForecastCoreDataModel], heignt: CGFloat){
        var minimalTemp: Double = 1000
        var maximumTemp: Double = -1000
        var tempArray: [Int] = []

        forecast.forEach({
            if $0.temp < minimalTemp {
                minimalTemp = $0.temp
            }
            if $0.temp > maximumTemp {
                maximumTemp = $0.temp
            }
            let currentTemp = ValueConverter.shared.getIntTemp(for: $0.temp)
            tempArray.append(currentTemp)

        })

        let viewForPointHeight = heignt - 20
        var oneDegreeHeight: CGFloat = 0
        var zeroLineCenterYAchor: CGFloat = 0

        let currentMinimalTemp = ValueConverter.shared.getIntTemp(for: minimalTemp)
        let currentMaximumTemp = ValueConverter.shared.getIntTemp(for: maximumTemp)

        if currentMinimalTemp >= 0 && currentMaximumTemp > 0 {

            oneDegreeHeight = viewForPointHeight/CGFloat(currentMaximumTemp)

        } else if currentMinimalTemp < 0 && currentMaximumTemp <= 0 {
            zeroLineCenterYAchor = viewForPointHeight
            oneDegreeHeight = viewForPointHeight/CGFloat(-currentMinimalTemp)
        } else {
            oneDegreeHeight = viewForPointHeight/CGFloat(currentMaximumTemp-currentMinimalTemp)
            zeroLineCenterYAchor = oneDegreeHeight*CGFloat(-currentMinimalTemp)
        }
        for (index, temp) in tempArray.enumerated() {
            let nextTemp: Int? = {
                if index+1 == tempArray.count {
                    return nil
                }
                return tempArray[index+1]
            }()

            let point = PointInGrathView(
                oneDegreeHeight: oneDegreeHeight,
                zeroLineCenterYAchor: zeroLineCenterYAchor,
                currentTemp: temp,
                nextTemp: nextTemp
            )

            self.stackView.addArrangedSubview(point)
        }

    }
}
