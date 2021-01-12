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
    /* Realistically this will be arrays of one item. It its just to match the format
     received from WorldWeatherOnline */
    let weatherIconUrl: [StringValue]
    let chanceofrain: String
}
