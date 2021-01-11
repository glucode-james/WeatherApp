//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/11.
//

import Foundation

class DailyWeather: Decodable {
    let date: String
    let maxtempC: String
    let mintempC: String

    let hourly: [HourlyWeather]
}
