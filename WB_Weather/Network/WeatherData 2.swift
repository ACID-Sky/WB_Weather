//
//  WeatherData.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 14.04.2023.
//

import Foundation

struct CurrentWeather: Decodable {
    let weather:[Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let dt: Double
    let sys: CurrentSys
    let timezone: Double
}

struct CurrentSys: Decodable {
    let sunrise: Double
    let sunset: Double
}

struct WeatherForecast: Decodable {
    let list: [List]
}

struct List: Decodable {
    let dt: Double
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let pop: Double
    let sys: Sys
    let dt_txt: String
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int16

    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Decodable {
    let all: Int16
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
}

struct Sys: Decodable {
    let pod: String
}
