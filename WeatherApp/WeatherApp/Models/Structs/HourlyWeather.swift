//
//  HourlyWeather.swift
//  WeatherApp
//

import Foundation

struct HourlyWeather: Decodable {
    let time: String
    let tempC: String
    /* Realistically this will be arrays of one item. It its just to match the format
     received from WorldWeatherOnline */
    let weatherIconUrl: [StringValue]
    let chanceofrain: String

    func getWeatherIconURL() -> String {
        return weatherIconUrl.count > 0 ? weatherIconUrl[0].value : ""
    }
}
