//
//  APIModel.swift
//  WeatherApp
//

import Foundation

class APIModel {

    enum APIFunction {
        case search
        case weather

        func functionString() -> String {
            switch self {
            case .search:
                return "search.ashx"
            case .weather:
                return "weather.ashx"
            }
        }
    }

    static let apiKey = "1f0f03761a914185a72104639210701"
    private static let baseURL = "https://api.worldweatheronline.com/premium/v1/"

    private init() {

    }

    static func buildURL(for function: APIFunction, with params: [URLQueryItem]) -> URL? {
        guard var url = URLComponents(string: "\(APIModel.baseURL)\(function.functionString())") else {
            return nil
        }

        var queryItems = [
            URLQueryItem(name: "key", value: APIModel.apiKey),
            URLQueryItem(name: "format", value: "json")
        ]
        queryItems.append(contentsOf: params)

        url.queryItems = queryItems

        return url.url
    }
}
