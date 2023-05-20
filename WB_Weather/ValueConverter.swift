//
//  ValueConverter.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 11.05.2023.
//

import Foundation

struct ValueConverter {
    private let userDefaults = UserDefaults.standard


    static let shared: ValueConverter = {
        let instance = ValueConverter()
        return instance
    }()

    
    private init() {}

    func getTemp(for temp: Double) -> String {
        let temperatureInFahrenheit = self.userDefaults.bool(forKey: "temperatureInFahrenheit")

        let measure = Measurement(value: temp, unit: UnitTemperature.celsius)
        if temperatureInFahrenheit {
            let converted = measure.converted(to: .fahrenheit)
            return String(Int(converted.value))
        } else {
            return String(Int(measure.value))
        }
    }

    func getIntTemp(for temp: Double) -> Int {
        let temperatureInFahrenheit = self.userDefaults.bool(forKey: "temperatureInFahrenheit")

        let measure = Measurement(value: temp, unit: UnitTemperature.celsius)
        if temperatureInFahrenheit {
            let converted = measure.converted(to: .fahrenheit)
            return Int(converted.value)
        } else {
            return Int(measure.value)
        }
    }

    func getWindSpeed(for temp: Double) -> String {
        let windSpeedInMi = self.userDefaults.bool(forKey: "windSpeedInMi")

        let measure = Measurement(value: temp, unit: UnitSpeed.metersPerSecond)

        let formatter = MeasurementFormatter()
        if windSpeedInMi {
            let converted = measure.converted(to: .milesPerHour)
            return String(Int(converted.value)) + NSLocalizedString("windSpeed."+converted.unit.symbol, comment: "milesPerHour")

        } else {
            return String(Int(measure.value)) + NSLocalizedString("windSpeed."+measure.unit.symbol, comment: "m/s")
        }
    }

    func getFormat(timeStyleShort: Bool) -> String {
        let timeFormat12 = self.userDefaults.bool(forKey: "timeFormat12")

        let dayFormat = " E, dd MMMM"

        if timeFormat12 {
            let format = "hh:mm a"
            if timeStyleShort {
                return format
            } else {
                return format + dayFormat
            }
        } else {
            let format = "HH:mm"
            if timeStyleShort {
                return format
            } else {
                return format + dayFormat
            }
        }
    }
}

