//
//  City.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/11.
//

import Foundation

struct City: Codable, Equatable {
    let name: String
    let country: String

    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name && lhs.country == rhs.country
    }
}
