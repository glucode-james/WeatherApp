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

    func save(string: String, with key: UserDefaultsKey) {
        userDefaults.set(string, forKey: key.rawValue)
    }

    func string(with key: UserDefaultsKey) -> String? {
        return userDefaults.string(forKey: key.rawValue)
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
        guard let encodedData = userDefaults.array(forKey: UserDefaultsKey.cities.rawValue) as? [Data] else {
            return []
        }
        var cities = [City]()

        for data in encodedData {
            if let city = try? jsonDecoder.decode(City.self, from: data) {
                cities.append(city)
            }
        }

        return cities
    }
}
