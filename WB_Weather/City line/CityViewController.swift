//
//  CityViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

final class CityViewController: UIViewController {

    private lazy var cityView = CityView()

    override func loadView() {
        super.loadView()
        self.cityView.delegate = self
        self.view = cityView
        self.setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    private func setupView() {
//        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = "Location"
        self.navigationController?.navigationBar.tintColor = .systemBlue

        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.2"), style: .done, target: self, action: #selector(didTapLeftButton))
//        leftBarButton.tintColor = .systemBlue
        self.navigationItem.leftBarButtonItem = leftBarButton
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .done, target: self, action: #selector(didTapRightButton))
//        rightBarButton.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = rightBarButton

//        self.navigationItem.backBarButtonItem?.tintColor = .systemBlue

    }

    @objc private func didTapRightButton () {
        print("✅")
    }

    @objc private func didTapLeftButton () {
        let vc = UINavigationController(rootViewController: SettingsViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }


}

extension CityViewController: CityViewDelegate {
    func pushMoreInfoController() {
        let vc = DayViewController()
//        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.pushViewController(vc, animated: true)
        print("❤️")
    }

    func pushDiaryController() {
        let vc = DiaryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("❤️")
    }


}
