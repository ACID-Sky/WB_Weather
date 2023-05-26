//
//  Forecast.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.05.2023.
//

import Foundation
import UIKit

struct Forecast {
    let dateText: String
    let probabilityOfPrecipitationText: String // Вероятность осадков
    let weatherDescription: String // Описание прогноза
    let minTempText: String
    let maxTempText: String
    let partOfDay: String
    let groupOfWeather: GroupOfWeather
    let groupOfWeatherImage: UIImage
    let temText: String
    let feelsLikeText: String
    let feelsLikeImage: UIImage
    let windText: String
    let UIText: String
    let humidityText: String
    let cloudy: String
}
