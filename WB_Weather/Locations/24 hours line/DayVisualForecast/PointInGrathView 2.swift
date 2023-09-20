//
//  PointInGrathView.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 10.05.2023.
//

import UIKit

class PointInGrathView: UIView {
    private let oneDegreeHeight: CGFloat
    private let zeroLineCenterYAchor: CGFloat
    private let currentTemp: Int
    private let nextTemp: Int

    private lazy var pointImageView = UIImageView(image: UIImage(systemName: "circle"))
    private lazy var label = UILabel()

    init(
        oneDegreeHeight: CGFloat,
        zeroLineCenterYAchor: CGFloat,
        currentTemp: Int,
        nextTemp: Int?
    ) {
        self.oneDegreeHeight = oneDegreeHeight
        self.zeroLineCenterYAchor = zeroLineCenterYAchor
        self.currentTemp = currentTemp
        self.nextTemp = {
            guard let nextTemp = nextTemp else {
                return currentTemp
            }
            return nextTemp
        }()

        super.init(frame: .zero)
        self.setupParams()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawLine()
    }

    private func setupParams(){
        self.pointImageView.translatesAutoresizingMaskIntoConstraints = false
        self.pointImageView.tintColor = .black

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.text = ValueConverter.shared.getTemp(for: Double(currentTemp)) + "º"
        self.label.textColor = .black
        self.label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.label.textAlignment = .left

        self.addSubview(self.pointImageView)
        self.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.pointImageView.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant:  -self.zeroLineCenterYAchor-self.oneDegreeHeight*CGFloat(self.currentTemp)),
            self.pointImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.pointImageView.heightAnchor.constraint(equalToConstant: 4),
            self.pointImageView.widthAnchor.constraint(equalToConstant: 4),

            self.label.leadingAnchor.constraint(equalTo: self.pointImageView.leadingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.pointImageView.topAnchor, constant: -2)

        ])
    }

    private func drawLine(){
        let startPoint = self.pointImageView.center
        let finishYPoint = self.frame.height - self.zeroLineCenterYAchor - oneDegreeHeight*CGFloat(nextTemp)
        let finishXPoinr = self.frame.width + self.pointImageView.center.x
        let finishPoint = CGPoint(x: finishXPoinr, y: finishYPoint)

        let grathPath = UIBezierPath()
        grathPath.move(to: startPoint)
        grathPath.addLine(to: finishPoint)

        let grathLayer = CAShapeLayer()
        grathLayer.path = grathPath.cgPath
        grathLayer.fillColor = UIColor.clear.cgColor
        grathLayer.strokeColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1).cgColor
        grathLayer.lineWidth = 1
        grathLayer.strokeEnd = 1

        layer.addSublayer(grathLayer)

        let starYZeroLine = self.frame.height - self.zeroLineCenterYAchor
        let startZeroLine = CGPoint(x: 0, y: starYZeroLine)
        let finishZeroLine = CGPoint(x: finishXPoinr, y: starYZeroLine)

        let zeroLinePath = UIBezierPath()
        zeroLinePath.move(to: startZeroLine)
        zeroLinePath.addLine(to: finishZeroLine)

        let zeroLineLayer = CAShapeLayer()
        zeroLineLayer.path = zeroLinePath.cgPath
        zeroLineLayer.fillColor = UIColor.clear.cgColor
        zeroLineLayer.strokeColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1).cgColor
        zeroLineLayer.lineWidth = 0.5
        zeroLineLayer.lineDashPattern = [6, 3]
        zeroLineLayer.strokeEnd = 1

        layer.addSublayer(zeroLineLayer)
    }
}
