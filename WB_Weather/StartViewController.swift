//
//  ViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 03.04.2023.
//

import UIKit
import SpriteKit

enum Constants {
    static let size: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 120 : 150

}

final class StartViewController: UIViewController {

//    private lazy var SpriteView = RainFall()
    private lazy var logoView = UIImageView()
    private lazy var windView = UIImageView()
    private lazy var cloudView = UIImageView()
    private lazy var sunView = UIImageView()
    private lazy var label = UILabel()

    private lazy var rainView = UIImageView()
    private lazy var snowView = UIImageView()
    private lazy var sunnyView = UIImageView()
    private lazy var winterView = UIImageView()
    private lazy var weatherView = UIImageView()



    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupGradient()
        self.setupWeatherView()
        self.setupWinterView()
        self.setupSunnyView()
        self.setupSnowView()
        self.setupRainView()

//        SpriteView(scene: RainFall(), option: [.allowsTransparency])
//        self.setupLogoView()
//        self.setupCloudView()
//        self.setupWindView()
//        self.setupSunView()
//        self.setupLabel()
        DispatchQueue.main.asyncAfter(deadline:.now()+0.5, execute: {
            self.animateKeyframes {
                print("✅")
                let vc = MainViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        })
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0.35, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.35)
        gradientLayer.colors = [
            #colorLiteral(red: 0.7960784314, green: 0.06666666667, blue: 0.6705882353, alpha: 1).cgColor,
            #colorLiteral(red: 0.6, green: 0, blue: 0.6, alpha: 1).cgColor,
            #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1).cgColor,
        ]
        view.layer.addSublayer(gradientLayer)
    }

//    private func setupLogoView() {
//        self.logoView.translatesAutoresizingMaskIntoConstraints = false
//        self.logoView.image = UIImage(named: "WB")
//
//        self.view.addSubview(self.logoView)
//
//        NSLayoutConstraint.activate([
//            self.logoView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor),
//            self.logoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            self.logoView.widthAnchor.constraint(equalToConstant: Constants.size),
//            self.logoView.heightAnchor.constraint(equalToConstant: Constants.size),
//        ])
//    }
//
//    private func setupWindView() {
//        self.windView.translatesAutoresizingMaskIntoConstraints = false
//        self.windView.image = UIImage(systemName: "wind")
//        self.windView.alpha = 0
//        self.windView.tintColor = .systemBackground
//
//        self.view.addSubview(self.windView)
//
//        NSLayoutConstraint.activate([
//            self.windView.topAnchor.constraint(equalTo: self.view.centerYAnchor),
//            self.windView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.windView.widthAnchor.constraint(equalToConstant: Constants.size/2),
//            self.windView.heightAnchor.constraint(equalToConstant: Constants.size*2/6),
//        ])
//    }
//
//    private func setupCloudView() {
//        self.cloudView.translatesAutoresizingMaskIntoConstraints = false
//        self.cloudView.image = UIImage(systemName: "cloud.rain.fill")
//        self.cloudView.alpha = 0
//        self.cloudView.tintColor = .systemBackground
//
//        self.view.addSubview(self.cloudView)
//
//        NSLayoutConstraint.activate([
//            self.cloudView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -8),
//            self.cloudView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.cloudView.widthAnchor.constraint(equalToConstant: Constants.size/2),
//            self.cloudView.heightAnchor.constraint(equalToConstant: Constants.size*2/6),
//        ])
//    }
//
//    private func setupSunView() {
//        self.sunView.translatesAutoresizingMaskIntoConstraints = false
//        self.sunView.image = UIImage(systemName: "sun.max.fill")
//        self.sunView.alpha = 1
//        self.sunView.tintColor = .systemBackground
//
//        self.view.addSubview(self.sunView)
//
//        NSLayoutConstraint.activate([
//            self.sunView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: Constants.size*2/3),
//            self.sunView.centerXAnchor.constraint(equalTo: self.logoView.leadingAnchor),
//            self.sunView.widthAnchor.constraint(equalToConstant: Constants.size/2),
//            self.sunView.heightAnchor.constraint(equalToConstant: Constants.size*2/6),
//        ])
//    }
//
//    private func setupLabel() {
//        self.label.translatesAutoresizingMaskIntoConstraints = false
//        self.label.font = UIFont.boldSystemFont(ofSize: 24)
//        self.label.textColor = UIColor.systemBackground
//        self.label.text = "Weather."
//        self.label.alpha = 0
//
//        self.view.addSubview(self.label)
//
//        NSLayoutConstraint.activate([
//            self.label.topAnchor.constraint(equalTo: self.logoView.bottomAnchor),
//            self.label.centerXAnchor.constraint(equalTo: self.logoView.centerXAnchor),
//        ])
//    }

    private func setupRainView() {
        self.rainView.translatesAutoresizingMaskIntoConstraints = false
        self.rainView.image = UIImage(named: "rain")
        self.rainView.alpha = 0
        self.rainView.tintColor = .systemBackground

        self.view.addSubview(self.rainView)

        NSLayoutConstraint.activate([
            self.rainView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.rainView.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor),
            self.rainView.widthAnchor.constraint(equalToConstant: Constants.size),
            self.rainView.heightAnchor.constraint(equalToConstant: Constants.size),
        ])
    }

    private func setupSnowView() {
        self.snowView.translatesAutoresizingMaskIntoConstraints = false
        self.snowView.image = UIImage(named: "snow")
        self.snowView.alpha = 0
        self.snowView.tintColor = .systemBackground

        self.view.addSubview(self.snowView)

        NSLayoutConstraint.activate([
            self.snowView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.snowView.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor),
            self.snowView.widthAnchor.constraint(equalToConstant: Constants.size),
            self.snowView.heightAnchor.constraint(equalToConstant: Constants.size),
        ])
    }

    private func setupSunnyView() {
        self.sunnyView.translatesAutoresizingMaskIntoConstraints = false
        self.sunnyView.image = UIImage(named: "sun")
        self.sunnyView.alpha = 0
        self.sunnyView.tintColor = .systemBackground

        self.view.addSubview(self.sunnyView)

        NSLayoutConstraint.activate([
            self.sunnyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.sunnyView.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor),
            self.sunnyView.widthAnchor.constraint(equalToConstant: Constants.size),
            self.sunnyView.heightAnchor.constraint(equalToConstant: Constants.size),
        ])
    }

    private func setupWinterView() {
        self.winterView.translatesAutoresizingMaskIntoConstraints = false
        self.winterView.image = UIImage(named: "winter")
        self.winterView.alpha = 0
        self.winterView.tintColor = .systemBackground

        self.view.addSubview(self.winterView)

        NSLayoutConstraint.activate([
            self.winterView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.winterView.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor),
            self.winterView.widthAnchor.constraint(equalToConstant: Constants.size),
            self.winterView.heightAnchor.constraint(equalToConstant: Constants.size),
        ])
    }

    private func setupWeatherView() {
        self.weatherView.translatesAutoresizingMaskIntoConstraints = false
        self.weatherView.image = UIImage(named: "weather")
        self.weatherView.alpha = 0
        self.weatherView.tintColor = .systemBackground

        self.view.addSubview(self.weatherView)

        NSLayoutConstraint.activate([
            self.weatherView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.weatherView.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor),
            self.weatherView.widthAnchor.constraint(equalToConstant: Constants.size),
            self.weatherView.heightAnchor.constraint(equalToConstant: Constants.size),
        ])
    }
    private func animateKeyframes(completion: @escaping () -> Void) {

        UIView.animateKeyframes(withDuration: 10,
                                delay: 0,
                                options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.1) {
                self.rainView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.2) {
                self.rainView.transform = CGAffineTransform(scaleX: 6.0, y: 6.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2,
                               relativeDuration: 0.1) {
                self.rainView.alpha = 0
                self.snowView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2,
                               relativeDuration: 0.2) {
                self.snowView.transform = CGAffineTransform(scaleX: 6.0, y: 6.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4,
                               relativeDuration: 0.1) {
                self.snowView.alpha = 0
                self.sunnyView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4,
                               relativeDuration: 0.2) {
                self.sunnyView.transform = CGAffineTransform(scaleX: 6.0, y: 6.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6,
                               relativeDuration: 0.1) {
                self.sunnyView.alpha = 0
                self.winterView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6,
                               relativeDuration: 0.2) {
                self.winterView.transform = CGAffineTransform(scaleX: 6.0, y: 6.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.8,
                               relativeDuration: 0.1) {
                self.winterView.alpha = 0
                self.weatherView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.8,
                               relativeDuration: 0.2) {
                self.weatherView.transform = CGAffineTransform(scaleX: 6.0, y: 6.0)
            }

        } completion: { _ in
            completion()
        }
    }

//    private func animateKeyframes(completion: @escaping () -> Void) {
//        let startCloudCenterPoint = self.cloudView.center
//        let logoXCenterPoint = self.logoView.center.x
//
//        UIView.animateKeyframes(withDuration: 7,
//                                delay: 0,
//                                options: .calculationModeCubic) {
//            UIView.addKeyframe(withRelativeStartTime: 0,
//                               relativeDuration: 0.3) {
//                self.sunView.center = CGPoint(x: logoXCenterPoint, y: startCloudCenterPoint.y + 8)
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.45,
//                               relativeDuration: 0.1) {
//                self.sunView.alpha = 0
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.65,
//                               relativeDuration: 0.1) {
//                self.sunView.alpha = 1
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.8,
//                               relativeDuration: 0.1) {
//                self.sunView.alpha = 0
//                self.label.alpha = 1
//            }
//
//            UIView.addKeyframe(withRelativeStartTime: 0.2,
//                               relativeDuration: 0.3) {
//                self.cloudView.center = CGPoint(x: logoXCenterPoint, y: startCloudCenterPoint.y)
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.6,
//                               relativeDuration: 0.3) {
//                self.cloudView.center = CGPoint(x: (self.view.frame.width - startCloudCenterPoint.x), y: startCloudCenterPoint.y)
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.3,
//                               relativeDuration: 0.2) {
//                self.cloudView.alpha = 1
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.65,
//                               relativeDuration: 0.2) {
//                self.cloudView.alpha = 0
//            }
//
//
//
//            UIView.addKeyframe(withRelativeStartTime: 0.1,
//                               relativeDuration: 0.05) {
//                self.windView.alpha = 1
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.15,
//                               relativeDuration: 0.1) {
//                self.windView.alpha = 0
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.25,
//                               relativeDuration: 0.05) {
//                self.windView.alpha = 1
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.3,
//                               relativeDuration: 0.1) {
//                self.windView.alpha = 0
//            }
//
//
//            UIView.addKeyframe(withRelativeStartTime: 0.55,
//                               relativeDuration: 0.05) {
//                self.windView.alpha = 1
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.6,
//                               relativeDuration: 0.1) {
//                self.windView.alpha = 0
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.7,
//                               relativeDuration: 0.05) {
//                self.windView.alpha = 1
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.75,
//                               relativeDuration: 0.1) {
//                self.windView.alpha = 0
//            }
//        } completion: { _ in
//            completion()
//        }
//    }

}

class RainFall: SKScene {

    override func sceneDidLoad() {

        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill

        anchorPoint = CGPoint(x: 0.5, y: 1)

        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        addChild(node)

        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}
