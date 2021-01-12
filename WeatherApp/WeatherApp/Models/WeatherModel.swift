//
//  WeatherModel.swift
//  WeatherApp
//

import Foundation

/**
 This models exists to load weather status for given cities.
 */
class WeatherModel {

    func lookupWeather(for city: City, completion: @escaping  (_ success: Bool,
                                                               _ message: String,
                                                               _ currentConditions: CurrentConditions?,
                                                               _ dailyWeather: [DailyWeather]?) -> Void) {
        // We will use the lat/lon search. Names might have duplicates or overlap
        
    }
}
