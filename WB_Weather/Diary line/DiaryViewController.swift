//
//  CityViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

final class DiaryViewController: UIViewController {

    private lazy var diaryView = DiaryView()

    override func loadView() {
        super.loadView()
        self.diaryView.backgroundColor = .systemBackground
        self.view = diaryView
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
        self.navigationItem.title = "Diary weather report"

//        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.2"), style: .done, target: self, action: #selector(didTapLeftButton))
//        leftBarButton.tintColor = .systemBlue
//        self.navigationItem.leftBarButtonItem = leftBarButton
//        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .done, target: self, action: #selector(didTapRightButton))
//        rightBarButton.tintColor = .systemBlue
//        self.navigationItem.rightBarButtonItem = rightBarButton

    }

//    @objc private func didTapRightButton () {
//        print("✅")
//    }
//
//    @objc private func didTapLeftButton () {
//        let vc = UINavigationController(rootViewController: SettingsViewController())
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
//    }


}

