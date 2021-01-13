//
//  LocalSearchCityViewModel.swift
//  WeatherApp
//

import Foundation

class LocalSearchCityViewModel: BaseCityViewModel {

    override init() {

    }

    override func cityViewModel(search value: String) {
        // Load up all the local cities
        let storedCities = UserDefaultsModel.getInstance().cities()

        // filter them based on the search term
        if value.isEmpty {
            self.cities = storedCities
        } else {
            self.cities = storedCities.filter({ $0.areaName.count > 0 &&
                                                $0.areaName[0].value.lowercased().contains(value.lowercased()) })
        }

        // update the delegate
        delegate?.cityViewModel(updated: self, with: true, message: "")
    }

    /**
     Saved the given city to the locally stored city list, and then sets it to the currently active city.
     */
    func setCurrent(city: City) {
        var cities = UserDefaultsModel.getInstance().cities()

        if !cities.contains(city) {
            cities.append(city)
            cities.sort {
                ($0.areaName.count > 0 ? $0.areaName[0].value : "") <
                    ($1.areaName.count > 0 ? $1.areaName[0].value : "")
            }

            UserDefaultsModel.getInstance().save(cities: cities)
        }

        UserDefaultsModel.getInstance().saveSelected(city: city)
    }
}
