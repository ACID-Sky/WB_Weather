//
//  StringExtention.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 20.05.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
