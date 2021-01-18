//
//  WeatherModel.swift
//  WeatherApp
//

import Foundation

/**
 This models exists to load weather status for given cities.
 */
class WeatherModel {

    func lookupWeather(lat: String,
                       long: String,
                       completion: @escaping  (_ success: Bool,
                                               _ message: String,
                                               _ currentConditions: CurrentConditions?,
                                               _ dailyWeather: [DailyWeather]?) -> Void) {
        // We will use the lat/lon search. Names might have duplicates or overlap
        guard let url = APIModel.buildURL(for: APIModel.APIFunction.weather,
                                          with: [URLQueryItem(name: "q", value: "\(lat),\(long)")]) else {
            completion(false, "Invalid URL", nil, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            self.handleSearchResponse(data: data, response: response, error: error, completion: completion)
        }

        task.resume()
    }

    func lookupWeather(for city: City, completion: @escaping  (_ success: Bool,
                                                               _ message: String,
                                                               _ currentConditions: CurrentConditions?,
                                                               _ dailyWeather: [DailyWeather]?) -> Void) {
        self.lookupWeather(lat: city.latitude, long: city.longitude, completion: completion)
    }

    private func handleSearchResponse(data: Data?,
                                      response: URLResponse?,
                                      error: Error?,
                                      completion: @escaping  (_ success: Bool,
                                                              _ message: String,
                                                              _ currentConditions: CurrentConditions?,
                                                              _ dailyWeather: [DailyWeather]?) -> Void) {

        var success = false
        var message = "Invalid server response."
        var currentConditions: CurrentConditions?
        var dailyWeather: [DailyWeather]?

        if let error = error {
            message = error.localizedDescription
        } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            message = "Unexpected server response. Please try again."
        } else if let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data,
                                                               options: .allowFragments) as? [String: Any] {
            // Process the response
            if let jsonData = json["data"] as? [String: Any] {
                if let jsonError = jsonData["error"] as? [[String: String]],
                   jsonError.count >= 1,
                   let jsonMessage = jsonError[0]["msg"] {
                    message = jsonMessage
                } else if let decodedWeather = handleWeatherDecode(jsonData: jsonData) {

                    success = true
                    message = ""
                    currentConditions = decodedWeather.currentConditions
                    dailyWeather = decodedWeather.dailyWeather
                } else {
                    message = "Unexpected server response. Please try again."
                }
            }
        }

        completion(success, message, currentConditions, dailyWeather)
    }

    private func handleWeatherDecode(jsonData: [String: Any]) -> (currentConditions: CurrentConditions?, dailyWeather: [DailyWeather]?)? {

        if let currentConditionJson = jsonData["current_condition"] as? [[String: Any]],
                  currentConditionJson.count >= 1,
                  let weatherJson = jsonData["weather"] as? [[String: Any]] {

            let decoder = JSONDecoder()

            if let encodedCurrentConditions = try? JSONSerialization.data(withJSONObject: currentConditionJson[0],
                                                                          options: .prettyPrinted),
               let encodedWeather = try? JSONSerialization.data(withJSONObject: weatherJson,
                                                                options: .prettyPrinted) {

                return (try? decoder.decode(CurrentConditions.self, from: encodedCurrentConditions),
                        try? decoder.decode([DailyWeather].self, from: encodedWeather))
            }
        }

        return nil
    }
}
