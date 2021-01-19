//
//  AggregateDailyData.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/19.
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
