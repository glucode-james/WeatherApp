//
//  BaseCityViewModel.swift
//  WeatherApp
//

import Foundation

protocol CityDataSource {
    func cityViewModel(search value: String)
    func cityViewModelCityCount() -> Int
    func cityViewModelCity(at index: Int) -> City?
}

protocol CityViewModelDelegate: class {
    func cityViewModel(updated dataSource: CityDataSource, with error: Bool, message: String)
}

class BaseCityViewModel: CityDataSource {
    internal var cities = [City]()

    weak var delegate: CityViewModelDelegate?

    internal init() {}

    func cityViewModel(search value: String) {
        // This must be overridden in the extensions
    }

    func cityViewModelCityCount() -> Int {
        return cities.count
    }

    func cityViewModelCity(at index: Int) -> City? {
        if index < 0 || index >= cities.count {
            return nil
        }

        return cities[index]
    }
}
