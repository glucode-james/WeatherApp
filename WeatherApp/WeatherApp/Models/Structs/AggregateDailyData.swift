//
//  AggregateDailyData.swift
//  WeatherApp
//

import Foundation
import UIKit

struct AggregateDailyData {
    let dailyWeather: DailyWeather
    let formattedDate: String

    let chanceOfRain: String
    let chanceOfRainImage: UIImage?

    let minTempURL: String
    let maxTempURL: String
    let formattedTemp: String
}
