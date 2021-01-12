//
//  CurrentConditions.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/11.
//

import Foundation

struct CurrentConditions: Decodable {
    let temp_C: String
    /* Realistically these will be arrays of one item. It its just to match the format
     received from WorldWeatherOnline */
    let weatherIconUrl: [StringValue]
    let weatherDesc: [StringValue]
    let FeelsLikeC: String
}
