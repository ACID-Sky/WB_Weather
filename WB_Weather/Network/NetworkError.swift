//
//  NetworkError.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 11.04.2023.
//

import Foundation

enum NetworkError: Error, CustomDebugStringConvertible {
    case server(reason: String)
    case parse(description: String)
    case encode(description: String)
    case unknown

    var debugDescription: String {
        switch self {
        case .server(let reason):
            return "Ошибка сервера: \(reason)"
        case let .parse(description), let .encode(description):
            return description
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}
