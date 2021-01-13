//
//  WeatherViewModel.swift
//  WeatherApp
//

import Foundation

protocol WeatherViewModelDelegate: class {
    func weatherViewModel(weatherUpdated weatherViewModel: WeatherViewModel, error: Bool, message: String)
}

class WeatherViewModel {

    private let weatherModel: WeatherModel

    weak var delegate: WeatherViewModelDelegate?

    private var currentConditions: CurrentConditions?
    private var dailyWeather: [DailyWeather]?

    /* This is composed when receiving weather updates, not just the list from today.
     It should be the next five hourly entries, calculated on load and the current time. */
    private var hourlyWeather: [HourlyWeather]?

    private var timeFormatter: DateFormatter

    init() {
        self.weatherModel = WeatherModel()

        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HHss"
    }

    func getSelectedCity() -> City? {
        return UserDefaultsModel.getInstance().selectedCity()
    }

    func loadWeatherForSelectedCity() {
        guard let city = getSelectedCity() else {
            delegate?.weatherViewModel(weatherUpdated: self, error: true, message: "No city currently selected.")

            return
        }

        self.loadWeatherFor(lat: city.latitude, long: city.longitude)
    }

    func loadWeatherFor(lat: String, long: String) {
        weatherModel.lookupWeather(lat: lat,
                                   long: long,
                                   completion: {(success, message, currentConditions, dailyWeather) in

                                    // set the local data
                                    self.currentConditions = currentConditions
                                    self.dailyWeather = dailyWeather

                                    self.calculateHourlyWeather(dailyWeather: dailyWeather)

                                    // call the delegate
                                    self.delegate?.weatherViewModel(weatherUpdated: self, error: !success, message: message)
        })
    }

    func getCurrentConditions() -> CurrentConditions? {
        return currentConditions
    }

    func getDailyWeather(at index: Int) -> DailyWeather? {
        guard let dailyWeather = dailyWeather else {
            return nil
        }

        if index < 0 || index >= dailyWeather.count {
            return nil
        }

        return dailyWeather[index]
    }

    func getHourlyWeather(at index: Int) -> HourlyWeather? {
        // This will not look directly at todays list, but rather the calculated list
        guard let hourlyWeather = hourlyWeather else {
            return nil
        }

        if index < 0 || index >= hourlyWeather.count {
            return nil
        }

        return hourlyWeather[index]
    }

    private func calculateHourlyWeather(dailyWeather: [DailyWeather]?) {
        if let dailyWeather = dailyWeather {
            // Calculate the hourly weather
            let currentDate = Date()
            var hourly = [HourlyWeather]()

            for daily in dailyWeather where hourly.count < 5 {
                for hour in daily.hourly where hourly.count < 5 {

                    guard let hourDate = self.formatTime(date: daily.date, time: hour.time) else {
                        break
                    }

                    let alreadyFoundFirstFutureHour = hourly.count > 0

                    if alreadyFoundFirstFutureHour || hourDate > currentDate {
                        hourly.append(hour)
                    }
                }
            }
            self.hourlyWeather = hourly

        } else {
            self.hourlyWeather = nil
        }
    }

    private func formatTime(date: String, time: String) -> Date? {
        var paddedTime = time
        while paddedTime.count < 4 {
            paddedTime = "0\(paddedTime)"
        }

        return timeFormatter.date(from: "\(date) \(paddedTime)")
    }
}
