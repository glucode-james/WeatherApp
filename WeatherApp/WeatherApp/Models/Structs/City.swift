//
//  City.swift
//  WeatherApp
//

import Foundation

struct City: Codable, Equatable {
    /* Realistically these will be arrays of one item. It its just to match the format
     received from WorldWeatherOnline */
    let areaName: [StringValue]
    let country: [StringValue]

    let latitude: String
    let longitude: String

    /* This is for test purposes, in practice it will be decoded from JSON */
    init(city: String, country: String, latitude: String, longitude: String) {
        self.areaName = [StringValue(value: city)]
        self.country = [StringValue(value: country)]

        self.latitude = latitude
        self.longitude = longitude
    }

    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
