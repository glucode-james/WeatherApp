//
//  CityModel.swift
//  WeatherApp
//

import Foundation

/**
 This models exists search for and return cities.
 */
class CityModel {

    func doCitySearch(search value: String, completion: @escaping  (_ success: Bool,
                                                                    _ message: String,
                                                                    _ cities: [City]) -> Void) {

        guard let url = APIModel.buildURL(for: APIModel.APIFunction.search,
                                          with: [URLQueryItem(name: "q", value: value)]) else {
            completion(false, "Invalid URL", [])
            return
        }

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            self.handleSearchResponse(data: data, response: response, error: error, completion: completion)
        }

        task.resume()
    }

    private func handleSearchResponse(data: Data?,
                                      response: URLResponse?,
                                      error: Error?,
                                      completion: @escaping  (_ success: Bool,
                                                              _ message: String,
                                                              _ cities: [City]) -> Void) {

        var success = false
        var message = "Invalid server response."
        var cities = [City]()

        if let error = error {
            message = error.localizedDescription
        } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            message = "Unexpected server response. Please try again."
        } else if let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data,
                                                               options: .allowFragments) as? [String: Any] {
            // Process the response
            if let jsonData = json["data"] as? [String: Any] {
                message = getDataErrorMessage(jsonData)
            } else if let jsonSearchAPI = json["search_api"] as? [String: Any],
                      let jsonResult = jsonSearchAPI["result"] as? [[String: Any]] {
                let decoder = JSONDecoder()
                if let encodedJSON = try? JSONSerialization.data(withJSONObject: jsonResult,
                                                                 options: .prettyPrinted),
                   let cityResult = try? decoder.decode([City].self, from: encodedJSON) {
                    success = true
                    message = ""

                    cities.append(contentsOf: cityResult)
                } else {
                    message = "Unexpected server response. Please try again."
                }
            }
        }

        completion(success, message, cities)
    }

    func getDataErrorMessage(_ jsonData: [String: Any]) -> String {
        if let jsonError = jsonData["error"] as? [[String: String]],
           jsonError.count >= 1,
           let jsonMessage = jsonError[0]["msg"] {

            return jsonMessage
        } else {
            return "Unexpected server response. Please try again."
        }
    }
}
