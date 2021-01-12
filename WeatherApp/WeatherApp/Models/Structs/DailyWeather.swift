//
//  DailyWeather.swift
//  WeatherApp
//

import Foundation

class DailyWeather: Decodable {
    let date: String
    let maxtempC: String
    let mintempC: String

    let hourly: [HourlyWeather]
}
