//
//  Alerts.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 17.05.2023.
//

import Foundation
import UIKit

struct Alerts {
    func showAlert(with
                   title: String,
                   message: String,
                   preferredStyle: UIAlertController.Style
    ) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle
        )


        let text = "ok.button".localized
        let yesAction = UIAlertAction(title: text, style: .default)

        alert.addAction(yesAction)
        return alert
    }
}
