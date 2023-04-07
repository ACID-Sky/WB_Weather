//
//  ShortDayInfo.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 06.04.2023.
//

import Foundation

public struct ShortDayInfo {
    public let time: String
    public let image: String
    public var degrees: Int

    public init(image: String, degrees: Int, time: String) {
        self.image = image
        self.degrees = degrees
        self.time = time
    }
}

public let toDay: [ShortDayInfo] = [
    ShortDayInfo(image: "cloud.rain.fill", degrees: 6, time: "1"),
    ShortDayInfo(image: "cloud.rain.fill", degrees: 5, time: "2"),
    ShortDayInfo(image: "cloud.fill", degrees: 4, time: "3"),
    ShortDayInfo(image: "cloud.fill", degrees: 3, time: "4"),
    ShortDayInfo(image: "cloud.fill", degrees: 2, time: "5"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 3, time: "6"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 4, time: "7"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 5, time: "8"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 6, time: "9"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 7, time: "10"),
    ShortDayInfo(image: "sun.max.fill", degrees: 8, time: "11"),
    ShortDayInfo(image: "sun.max.fill", degrees: 9, time: "12"),
    ShortDayInfo(image: "sun.max.fill", degrees: 10, time: "13"),
    ShortDayInfo(image: "sun.max.fill", degrees: 11, time: "14"),
    ShortDayInfo(image: "sun.max.fill", degrees: 12, time: "15"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 13, time: "16"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 15, time: "17"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 16, time: "18"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 20, time: "19"),
    ShortDayInfo(image: "cloud.sun.fill", degrees: 18, time: "20"),
    ShortDayInfo(image: "cloud.fill", degrees: 15, time: "21"),
    ShortDayInfo(image: "cloud.fill", degrees: 12, time: "22"),
    ShortDayInfo(image: "cloud.rain.fill", degrees: 8, time: "23"),
    ShortDayInfo(image: "cloud.rain.fill", degrees: 6, time: "00"),
]
