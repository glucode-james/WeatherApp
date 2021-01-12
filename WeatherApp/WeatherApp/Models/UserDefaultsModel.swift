//
//  UserDefaultsModel.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/11.
//

import Foundation

enum UserDefaultsKey: String {
    case selectedCity
    case cities
}

/**
 This models exists to store the user's last selected city, as well has cities they have selected
 previously. It doesnt retrieve any of it's data from WorldWeatherOnline, just saves what it is given.
 */
class UserDefaultsModel {

    private static let instance = UserDefaultsModel()

    static func getInstance() -> UserDefaultsModel {
        return instance
    }

    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    private init() {
        userDefaults = UserDefaults.standard
        jsonEncoder = JSONEncoder()
        jsonDecoder = JSONDecoder()
    }

    func selectedCity() -> City? {
        guard let cityData = userDefaults.object(forKey: UserDefaultsKey.selectedCity.rawValue) as? Data else {
            return nil
        }

        return try? jsonDecoder.decode(City.self, from: cityData)
    }

    func saveSelected(city: City) {
        if let encodedCity = try? jsonEncoder.encode(city) {
            userDefaults.set(encodedCity, forKey: UserDefaultsKey.selectedCity.rawValue)
        }
    }

    func save(cities: [City]) {
        let citiesData = cities.map { try? jsonEncoder.encode($0) }

        userDefaults.set(citiesData, forKey: UserDefaultsKey.cities.rawValue)
    }

    func cities() -> [City] {
        var cities = [City]()

        guard let encodedData = userDefaults.array(forKey: UserDefaultsKey.cities.rawValue) as? [Data] else {
            return cities
        }

        for data in encodedData {
            if let city = try? jsonDecoder.decode(City.self, from: data) {
                cities.append(city)
            }
        }

        return cities
    }
}
