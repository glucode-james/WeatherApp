//
//  CurrentConditions.swift
//  WeatherApp
//

import Foundation

struct CurrentConditions: Decodable {
    let temp_C: String
    /* Realistically these will be arrays of one item. It its just to match the format
     received from WorldWeatherOnline */
    let weatherIconUrl: [StringValue]
    let weatherDesc: [StringValue]
    let FeelsLikeC: String
    let uvIndex: String
    let windspeedKmph: String
    let winddirDegree: String
    let winddir16Point: String
    let humidity: String

    func getWeatherDesc() -> String {
        return weatherDesc.count > 0 ? weatherDesc[0].value : ""
    }

    func getWeatherIconURL() -> String {
        return weatherIconUrl.count > 0 ? weatherIconUrl[0].value : ""
    }
}
