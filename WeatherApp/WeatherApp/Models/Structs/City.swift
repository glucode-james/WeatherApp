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

    /* For keeping track of locally created objects, this will be nil on data from the backend. */
    let internalID: String?

    /* This is for test purposes, in practice it will be decoded from JSON */
    init(city: String, country: String, latitude: String, longitude: String, internalID: String? = nil) {
        self.areaName = [StringValue(value: city)]
        self.country = [StringValue(value: country)]

        self.latitude = latitude
        self.longitude = longitude

        self.internalID = internalID
    }

    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    /* The following two functions are to compensate for WWO's return format */
    func cityName() -> String {
        return self.areaName.count > 0 ? areaName[0].value : ""
    }

    func countryName() -> String {
        return self.country.count > 0 ? country[0].value : ""
    }
}
