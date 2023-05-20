//
//  NetworkService.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 11.04.2023.
//

import Foundation

enum Requestype {
    case getGeocodeLocation
    case getCoordinate
    case cuurentForecast
    case daysForecast
}

protocol NetworkServicePorotocol: AnyObject {

    /// Создаём URLComponent
    /// - Parameters:
    ///   - requestType: тип запроса
    ///      - Case:  getGeocodeLocation - получить название локации по координатам
    ///      - Case:  getCoordinate -  получить координаты и название по названию локации
    ///      - Case:  cuurentForecast - получить текущий прогноз погоды
    ///      - Case:  daysForecast - получить прогноз погоды на 5 дней раз в 3 часа
    ///   - location: Локация для которой нужно создать компонент
    /// - Returns: Возвращает URL для запроса
    func urlComponentsForCoordinate(
        for requestType: Requestype,
        location: Locations
    ) -> URLComponents

    /// Получить локацию
    /// - Parameters:
    ///   - endPoint: URLComponent запроса
    ///   - completion: экземпляр CoordinateAPIAnswer
    func fetchLocation(
        usingEndPoint endPoint: URLComponents,
        completion: @escaping (Result<CoordinateAPIAnswer, NetworkError>) -> Void
    )

    /// Получить прогноз погоды на 5 дней по 3 часа
    /// - Parameters:
    ///   - endPoint: URLComponent запроса
    ///   - completion: экземпляр WeatherForecast
    func fetchWeather(
        usingEndPoint endPoint: URLComponents,
        completion: @escaping (Result<WeatherForecast, NetworkError>) -> Void
    )

    /// Получить прогноз текущей погоды
    /// - Parameters:
    ///   - endPoint: URLComponent запроса
    ///   - completion: экземпляр WeatherForecast
    func fetchCurrentWeather(
        usingEndPoint endPoint: URLComponents,
        completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void
    )

}


final class NetworkService {
    private func fetchData(
        usingEndPoint endPoint: URLComponents,
        completion: @escaping (Result<Any, NetworkError>) -> Void
    ) {
        guard let url = endPoint.url else {
            completion(.failure(.unknown))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.server(reason: error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            completion(.success(data))
        }.resume()
    }
}



extension NetworkService: NetworkServicePorotocol {


    func urlComponentsForCoordinate(
        for requestType: Requestype,
        location: Locations
    ) -> URLComponents {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"

        switch requestType {
        case .getGeocodeLocation, .getCoordinate:
            urlComponents.host = "geocode-maps.yandex.ru"
            urlComponents.path = "/1.x"
            urlComponents.queryItems = [
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "apikey", value: "411db0cc-8c04-474f-8d94-803938f91fad"),
                URLQueryItem(name: "kind", value: "locality"),
                URLQueryItem(name: "results", value: "1"),
                URLQueryItem(name: "lang", value: "urlComponents.queryItems.geocode.lang".localized),
            ]
        case .cuurentForecast, .daysForecast:
            urlComponents.host = "api.openweathermap.org"
            urlComponents.queryItems = [
                URLQueryItem(name: "lat", value: location.locationLatitude),
                URLQueryItem(name: "lon", value: location.locationLongitude),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang", value: "urlComponents.queryItems.forecast.lang".localized),
                URLQueryItem(name: "appid", value: "6cc466710a9af41fc70603dbd8eff188"),
            ]
        }

        switch requestType {
        case .getGeocodeLocation:
            let coordinate = location.locationLatitude + ", " + location.locationLongitude
            urlComponents.queryItems?.append(URLQueryItem(name: "geocode", value: coordinate))
            urlComponents.queryItems?.append(URLQueryItem(name: "sco", value: "latlong"))

        case .getCoordinate:
            urlComponents.queryItems?.append( URLQueryItem(name: "geocode", value: location.locationName))

        case .cuurentForecast:
            urlComponents.path = "/data/2.5/weather"
        case .daysForecast:
            urlComponents.path = "/data/2.5/forecast"
        }

        return urlComponents
    }

    func fetchLocation(
        usingEndPoint endPoint: URLComponents,
        completion: @escaping (Result<CoordinateAPIAnswer, NetworkError>) -> Void
    ) {
        self.fetchData(usingEndPoint: endPoint) { result in
            switch result {
            case .success(let result):
                guard let data = result as? Data else {
                    completion(.failure(.unknown))
                    return
                }
                do {
                    let location = try JSONDecoder().decode(CoordinateAPIAnswer.self, from: data)
                    completion(.success(location))
                } catch {
                    completion(.failure(.parse(description: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchWeather(
        usingEndPoint endPoint: URLComponents,
        completion: @escaping (Result<WeatherForecast, NetworkError>) -> Void
    ) {

        self.fetchData(usingEndPoint: endPoint) { result in
            switch result {
            case .success(let result):
                guard let data = result as? Data else {
                    completion(.failure(.unknown))
                    return
                }
                do {
                    let forecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    completion(.success(forecast))
                } catch {
                    completion(.failure(.parse(description: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchCurrentWeather(
        usingEndPoint endPoint: URLComponents,
        completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void
    ) {

        self.fetchData(usingEndPoint: endPoint) { result in
            switch result {
            case .success(let result):
                guard let data = result as? Data else {
                    completion(.failure(.unknown))
                    return

                }
                do {
                    let forecast = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    completion(.success(forecast))
                } catch {
                    completion(.failure(.parse(description: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
