//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/11.
//

import Foundation

struct HourlyWeather: Decodable {
    let time: String
    let tempC: String
    let weatherIconUrl: [StringValue]
    let chanceofrain: String
}
