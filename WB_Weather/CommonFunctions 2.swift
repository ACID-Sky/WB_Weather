//
//  CommonFunctions.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 04.05.2023.
//

import Foundation
import UIKit

enum PartOfDay: String {
    case allDay
    case day = "d"
    case night = "n"
}

enum GroupOfWeather: String {
    case unknow = "Unknow"
    case rain = "Rain"
    case snow = "Snow"
    case extreme = "Extreme"
    case clear = "Clear"
    case clouds = "Clouds"

}

struct CommonFunctions {
    /// Получение прогнозв погоды для части одного дня и  текстовое обозначение даты этого дня
    /// - Parameters:
    ///   - forecasts: Массив прогнозов погоды
    ///   - dayIndex: для какого дня ищем прогнозы по инексу от текущего, где текущи = 0 (если от текущего дня осталось меньше 3 часов, то по нему данных не будет)
    ///   - partOfDay: для какой части дня нужен прогноз (весь день, день, вечер)
    ///   - dateFormat: В каком формате нужно вернуть обозначение дня
    /// - Returns: структура DayForecast, где findDayForecasts массив прогнозов погоды, dayName - текстовое обозначение дня, для которого отобраны прогнозы
    func getFindDayForecasts(
        for forecasts: [WeatherForecastCoreDataModel],
        dayIndex: Int,
        partOfDay: PartOfDay,
        dateFormat: String
    ) -> Forecast {
        let dateFormatter = DateFormatter()
        let timezone = {
            if forecasts.count == 0 {
                return 0
            } else{
                return Int(forecasts[0].location?.currentWeather?.timezone ?? 0)
            }
        }()
        dateFormatter.timeZone = TimeZone(secondsFromGMT:timezone)
        dateFormatter.locale = Locale(identifier: ValueConverter.shared.getLocal()) 
        dateFormatter.dateFormat = dateFormat

        let nowOnGreenwich = Int(Date().timeIntervalSince1970)
        let timeInLocation = (nowOnGreenwich + timezone)%86400
        let startToDayUnixInLocationOnGreenwich = nowOnGreenwich - timeInLocation
        var dayIndex = dayIndex

        if timeInLocation >= 75600 {
            dayIndex += 1
        }

        let startDayInLocationForFind = Double(startToDayUnixInLocationOnGreenwich + (86400 * dayIndex))
        let finishDayInLocationForFind = startDayInLocationForFind + 86400

        var findDayForecasts: [WeatherForecastCoreDataModel] = []
        forecasts.forEach({
            if $0.dateOfForecast >= startDayInLocationForFind &&
                $0.dateOfForecast < finishDayInLocationForFind {
                if partOfDay == .allDay {
                    findDayForecasts.append($0)
                }
                if $0.partOfDay == partOfDay.rawValue {
                    findDayForecasts.append($0)
                }
            }
        })
        let date = Date(timeIntervalSince1970: startDayInLocationForFind)
        let partOfdayText = {
            switch partOfDay {
            case .allDay:
                return ""
            case .day:
                return "Day"
            case .night:
                return "Night"
            }
        }()

        guard findDayForecasts.count != 0 else {
            let dayForecast = Forecast(
                dateText: dateFormatter.string(from: date),
                probabilityOfPrecipitationText: "??%",
                weatherDescription: "We don't have data at the data.",
                minTempText: "minº",
                maxTempText: "maxº",
                partOfDay: partOfdayText,
                groupOfWeather: .unknow,
                groupOfWeatherImage: UIImage(systemName: "globe.europe.africa.fill")!,
                temText: "??º",
                feelsLikeText: "??º",
                feelsLikeImage: UIImage(systemName: "thermometer.medium")!,
                windText: "We don't know",
                UIText: "We don't know",
                humidityText: "We don't know",
                cloudy: "??%"
            )
            return dayForecast
        }

        let countForecast = Double(findDayForecasts.count)
        var minTemp: Double = 1000
        var maxTemp: Double = -1000
        var temp: Double = 0
        var feelsLike: Double = 0
        var probabilityOfPrecipitation: Double = 0
        var coundWind: Double = 0
        var wind: Double = 0
        var windDegree: Double = 0
        var humidity: Double = 0
        var cloudy: Double = 0

        findDayForecasts.forEach({
            if $0.tempMin < minTemp {
                minTemp = $0.tempMin
            }
            if $0.tempMax > maxTemp {
                maxTemp = $0.tempMax
            }

            if $0.windSpeed > 0 {
                coundWind += 1
                wind += $0.windSpeed
                windDegree += $0.windDeg
            }
            temp += $0.temp
            feelsLike += $0.feelsLike
            probabilityOfPrecipitation += $0.probabilityOfPrecipitation
            humidity += Double($0.humidity)
            cloudy += Double($0.cloudsAll)
        })

        let averagePOP = Int(100 * probabilityOfPrecipitation/countForecast)
        let averegeTemp = temp/countForecast
        let averegeFellsLike = feelsLike/countForecast
        let averegeWind = wind/coundWind
        let averegeWindDegree = self.getWindDirection(for: windDegree/coundWind)
        let averegeHumidity = Int(humidity/countForecast)
        let averedgeCloudy = Int(cloudy/countForecast)
        let groupofWeatherText: GroupOfWeather = {
            if findDayForecasts[0].weatherMain == "Rain" {
                return .rain
            } else if findDayForecasts[0].weatherMain == "Snow" {
                return .rain
            } else if findDayForecasts[0].weatherMain == "Extreme" {
                return .extreme
            } else if findDayForecasts[0].weatherMain == "Clear" {
                return .clear
            } else if findDayForecasts[0].weatherMain == "Clouds" {
                return .clouds
            } else {
                print("🤡 New group", findDayForecasts[0].weatherMain ?? "nil")
                return .unknow
            }
        }()

        let groupofWeatherImage: UIImage = {
            switch groupofWeatherText {
            case .rain:
                return UIImage(named: "cloudAndRain")!
            case .snow:
                return UIImage(named: "13d")!
            case .extreme:
                return UIImage(named: "shtorm")!
            case .clear:
                return UIImage(named: "Sun")!
            case .clouds:
                return UIImage(named: "cloudBlue")!
            case .unknow:
                return UIImage(systemName: "globe.europe.africa.fill")!
            }
        }()

        let feelsLikeImage = {
            if averegeFellsLike < 4 {
                return UIImage(named: "snowthermometer")!
            } else {
                return UIImage(named: "sunthermometer")!
            }
        }()

        let dayForecast = Forecast(
            dateText: dateFormatter.string(from: date),
            probabilityOfPrecipitationText: String(averagePOP) + "%",
            weatherDescription: findDayForecasts[0].weatherDescription ?? "Unknow",
            minTempText: ValueConverter.shared.getTemp(for: minTemp) + "º",
            maxTempText: ValueConverter.shared.getTemp(for: maxTemp) + "º",
            partOfDay: partOfdayText,
            groupOfWeather: groupofWeatherText,
            groupOfWeatherImage: groupofWeatherImage,
            temText: ValueConverter.shared.getTemp(for: averegeTemp) + "º",
            feelsLikeText: ValueConverter.shared.getTemp(for: averegeFellsLike) + "º",
            feelsLikeImage: feelsLikeImage,
            windText: ValueConverter.shared.getWindSpeed(for: averegeWind) + " " + averegeWindDegree,
            UIText: "We don't have data",
            humidityText: String(averegeHumidity) + "%",
            cloudy: String(averedgeCloudy)  + "%"
        )
        return dayForecast
    }

    /// Получение текстового обозначения направления ветра из знаения градусов
    /// - Parameter degree: градусы ветра по прогнозу
    /// - Returns: Название направления ветра
    func getWindDirection(for degree: Double) -> String {
        if degree >= 0.0 &&
            degree > 348.75 &&
            degree <= 360.0 &&
            degree <= 11.25 {
            return "N"
        } else if degree > 11.25 &&
                    degree <= 33.75 {
            return "NNE"
        } else if degree > 33.75 &&
                    degree <= 56.25 {
            return "NE"
        } else if degree > 56.25 &&
                    degree <= 78.75 {
            return "ENE"
        } else if degree > 78.75 &&
                    degree <= 102.25 {
            return "E"
        } else if degree > 101.25 &&
                    degree <= 123.75 {
            return "ESE"
        } else if degree > 123.75 &&
                    degree <= 146.25 {
            return "SE"
        } else if degree > 146.25 &&
                    degree <= 168.75 {
            return "SSE"
        } else if degree > 168.75 &&
                    degree <= 191.25 {
            return "S"
        } else if degree > 191.25 &&
                    degree <= 213.75 {
            return "SSW"
        } else if degree > 213.75 &&
                    degree <= 236.25 {
            return "SW"
        } else if degree > 236.25 &&
                    degree <= 258.75 {
            return "WSW"
        } else if degree > 258.75 &&
                    degree <= 281.25 {
            return "W"
        } else if degree > 281.25 &&
                    degree <= 303.75 {
            return "WNW"
        } else if degree > 303.75 &&
                    degree <= 326.25 {
            return "NW"
        } else {
            return "NNW"
        }
    }

}



