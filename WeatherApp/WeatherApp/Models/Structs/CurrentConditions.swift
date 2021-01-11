//
//  CurrentConditions.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/11.
//

import Foundation

struct CurrentConditions: Decodable {
    let temp_C: String
    let weatherIconUrl: [StringValue]
    let weatherDesc: [StringValue]
    let FeelsLikeC: String
}
