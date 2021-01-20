//
//  WeatherViewModel.swift
//  WeatherApp
//

import Foundation
import UIKit

protocol WeatherViewModelDelegate: class {
    func weatherViewModel(weatherUpdated weatherViewModel: WeatherViewModel, error: Bool, message: String)
    func weatherViewModel(locationServicesDisabled weatherViewModel: WeatherViewModel)
}

class WeatherViewModel {

    private let baseMaxTemp = -1000
    private let baseMinTemp = 1000

    private let weatherModel: WeatherModel

    weak var delegate: WeatherViewModelDelegate?

    private var currentConditions: CurrentConditions?
    private var dailyWeather: [DailyWeather]?

    /* This is composed when receiving weather updates, not just the list from today.
     It should be the next five hourly entries, calculated on load and the current time. */
    private var hourlyWeather: [AggregateHourlyData]?

    /* Too many date formatters, but I think needed for the in and out formatting? */
    private let dailyInFormatter: DateFormatter
    private let dailyOutFormatter: DateFormatter
    private let timeInFormatter: DateFormatter
    private let timeOutFormatter: DateFormatter

    /* Rain drop images for reuse */
    private let emptyDrop = UIImage(named: "EmptyDrop")
    private let halfDrop = UIImage(named: "HalfDrop")
    private let fullDrop = UIImage(named: "FullDrop")

    var updateWeatherOnLocationUpdate = false

    init() {
        self.weatherModel = WeatherModel()

        /* Configure date formatters */
        dailyInFormatter = DateFormatter()
        dailyInFormatter.dateFormat = "yyyy-MM-dd"
        dailyOutFormatter = DateFormatter()
        dailyOutFormatter.dateFormat = "EEEE"
        timeInFormatter = DateFormatter()
        timeInFormatter.dateFormat = "yyyy-MM-dd HHss"
        timeOutFormatter = DateFormatter()
        timeOutFormatter.dateFormat = "HH:mm"
    }

    func useMyLocation() {
        // This must just be saved as the current city, not added to the list
        UserDefaultsModel.getInstance().saveSelected(city: MyLocationModel.myLocation)
    }

    func getSelectedCity() -> City? {
        return UserDefaultsModel.getInstance().selectedCity()
    }

    func loadWeatherForSelectedCity() {
        guard let city = getSelectedCity() else {
            delegate?.weatherViewModel(weatherUpdated: self, error: true, message: "No city currently selected.")

            return
        }

        // If we are using "My Location", check for or wait for coordinates, otherwise use the selected city
        if city.internalID == MyLocationModel.myLocationInternalID {
            loadWeatherForMyLocation()
        } else {
            self.loadWeatherFor(lat: city.latitude, long: city.longitude)
        }
    }

    private func loadWeatherForMyLocation() {
        if let location = MyLocationModel.getInstance().getCurrentLocation() {
            self.loadWeatherFor(lat: String(location.coordinate.latitude), long: String(location.coordinate.longitude))
        } else {
            updateWeatherOnLocationUpdate = true
            MyLocationModel.getInstance().delegate = self
            MyLocationModel.getInstance().startUpdating()
        }
    }

    func stopLocationUpdates() {
        MyLocationModel.getInstance().stopUpdating()
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

    func getDailyWeather(at index: Int) -> AggregateDailyData? {
        guard let dailyWeather = dailyWeather else {
            return nil
        }

        if index < 0 || index >= dailyWeather.count {
            return nil
        }

        let dayDate = index == 0 ? "Today" : dailyOutFormatter.string(from: dailyInFormatter.date(from: dailyWeather[index].date) ?? Date())
        let minMaxURL = getMinMaxURL(dayData: dailyWeather[index])
        let chanceOfRain = calculateDailyChanceOfRain(dayData: dailyWeather[index])
        let dailyData = AggregateDailyData(dailyWeather: dailyWeather[index],
                                           formattedDate: dayDate,
                                           chanceOfRain: "\(chanceOfRain)%",
                                           chanceOfRainImage: dropImageFor(chance: chanceOfRain),
                                           minTempURL: minMaxURL.minURL,
                                           maxTempURL: minMaxURL.maxURL,
                                           formattedTemp: "\(dailyWeather[index].maxtempC)°/\(dailyWeather[index].mintempC)°")
        return dailyData
    }

    func getHourlyWeather(at index: Int) -> AggregateHourlyData? {
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
            var hourly = [AggregateHourlyData]()

            for daily in dailyWeather where hourly.count < 5 {
                for hour in daily.hourly where hourly.count < 5 {

                    guard let hourDate = self.formatTime(date: daily.date, time: hour.time) else {
                        break
                    }

                    let alreadyFoundFirstFutureHour = hourly.count > 0

                    if alreadyFoundFirstFutureHour || hourDate > currentDate {
                        hourly.append(AggregateHourlyData(hourlyWeather: hour,
                                                          formattedTime: timeOutFormatter.string(from: hourDate),
                                                          chanceOfRainImage: dropImageFor(chance: Int(hour.chanceofrain) ?? 0)))
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

        return timeInFormatter.date(from: "\(date) \(paddedTime)")
    }

    private func dropImageFor(chance: Int) -> UIImage? {
        if chance > 70 {
            return fullDrop
        } else if chance > 20 {
            return halfDrop
        } else {
            return emptyDrop
        }
    }

    private func getMinMaxURL(dayData: DailyWeather) -> (minURL: String, maxURL: String) {
        /* Work out the min and max icon indexes to set. Also work out average chance of rain */
        var minTemp = baseMinTemp, maxTemp = baseMaxTemp
        var minURL = "", maxURL = ""
        for hourData in dayData.hourly {
            let hourTemp = Int(hourData.tempC)
            if hourTemp ?? baseMinTemp < minTemp {
                minTemp = hourTemp ?? baseMinTemp
                minURL = hourData.getWeatherIconURL()
            }
            if hourTemp ?? baseMaxTemp > maxTemp {
                maxTemp = hourTemp ?? baseMaxTemp
                maxURL = hourData.getWeatherIconURL()
            }
        }

        return (minURL, maxURL)
    }

    private func calculateDailyChanceOfRain(dayData: DailyWeather) -> Int {
        if dayData.hourly.count == 0 {
            return 0
        }

        var totalChanceOfRain = 0
        for hourlyData in dayData.hourly {
            totalChanceOfRain += Int(hourlyData.chanceofrain) ?? 0
        }

        return totalChanceOfRain / dayData.hourly.count
    }
}

extension WeatherViewModel: MyLocationModelDelegate {
    // MARK: - Delegate Functions
    func myLocationModel(locationUpdated myLocationModel: MyLocationModel) {
        if updateWeatherOnLocationUpdate,
           let location = myLocationModel.getCurrentLocation() {
            updateWeatherOnLocationUpdate = false
            self.loadWeatherFor(lat: String(location.coordinate.latitude), long: String(location.coordinate.longitude))
        }
    }

    func myLocationModel(locationServicesDisabled myLocationModel: MyLocationModel) {
        delegate?.weatherViewModel(locationServicesDisabled: self)
    }
}
