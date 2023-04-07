//
//  CityViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

final class DayViewController: UIViewController {

    private lazy var dayView = DayView()

    override func loadView() {
        super.loadView()
        self.setupView()
        self.dayView.backgroundColor = .systemBackground
        self.view = dayView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupView() {
        self.navigationItem.title = "Forecast for 24 hours"
//        self.navigationController?.navigationBar.barStyle = .black
////        self.navigationItem.backBarButtonItem?.tintColor = .systemBlue
    }
}

//extension DayViewController: DayViewDelegate {
//    func pushMoreInfoController() {
//        print("❤️")
//    }
//
//
//}
