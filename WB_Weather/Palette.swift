//
//  Palette.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 21.05.2023.
//

import Foundation
import UIKit

extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}

struct Palette {
    static var cellBackgroundColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), darkMode: #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1))
    static var cellTextColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    static var selectedCellBackgroundColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 0.7960784314, green: 0.06666666667, blue: 0.6705882353, alpha: 1), darkMode: #colorLiteral(red: 0.6, green: 0, blue: 0.6, alpha: 1))
    static var selectedCellTextColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    static var buttonBackgroundColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 0.7960784314, green: 0.06666666667, blue: 0.6705882353, alpha: 1), darkMode: #colorLiteral(red: 0.6, green: 0, blue: 0.6, alpha: 1))
    static var secondButtonBackground: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkMode: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    static var secontButtonText: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1), darkMode: #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1))
    static var buttonTextColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    static var borderColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    static var textColor: UIColor = UIColor.createColor(lightMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
}
