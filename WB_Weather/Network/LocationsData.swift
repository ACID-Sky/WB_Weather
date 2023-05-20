//
//  LocationsData.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 07.04.2023.
//

import Foundation

struct Locations {
    let id: Int32
    let locationName: String
    let locationLatitude: String
    let locationLongitude: String

    init(id: Int32, locationName: String, locationLatitude: String, locationLongitude: String) {
        self.id = id
        self.locationName = locationName
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
    }
}



struct CoordinateAPIAnswer: Decodable {
    let response: Response

}
struct Response: Decodable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

struct GeoObjectCollection: Decodable {
    let featureMember: [FeatureMember]
}


struct FeatureMember: Decodable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

struct GeoObject: Decodable {
    let description: String?
    let name: String
    let point: Point

    enum CodingKeys: String, CodingKey {
        case description, name
        case point = "Point"
    }
}
struct Point: Decodable {
    let pos: String
}

