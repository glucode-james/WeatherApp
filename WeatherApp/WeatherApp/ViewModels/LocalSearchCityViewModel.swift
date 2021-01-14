//
//  LocalSearchCityViewModel.swift
//  WeatherApp
//

import Foundation

class LocalSearchCityViewModel: BaseCityViewModel {

    override init() {
        super.init()

        // Set the initial list to all the current saved cities
        self.cities = UserDefaultsModel.getInstance().cities()
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
        delegate?.cityViewModel(updated: self, with: false, message: "")
    }

    func savedCityCount() -> Int {
        return UserDefaultsModel.getInstance().cities().count
    }

    /**
     Saved the given city to the locally stored city list, and then sets it to the currently active city.
     */
    func setCurrent(city: City) {
        var cities = UserDefaultsModel.getInstance().cities()

        if !cities.contains(city) {
            cities.append(city)
            cities.sort { $0.cityName() < $1.cityName() }

            UserDefaultsModel.getInstance().save(cities: cities)
        }

        UserDefaultsModel.getInstance().saveSelected(city: city)
    }

    func deleteSavedCity(at index: Int) {
        guard let city = cityViewModelCity(at: index) else {
            return
        }

        // Remove the city from the view controller cities
        cities.remove(at: index)

        // The city needs to be removed from the base list, not the current list in the view model
        var allCities = UserDefaultsModel.getInstance().cities()

        if allCities.contains(city),
           let firstIndex = allCities.firstIndex(of: city) {

            // Remove the city from the saved cities
            allCities.remove(at: firstIndex)
            UserDefaultsModel.getInstance().save(cities: allCities)
            // The UI will handle removing the element from the display, so I will no call a delegate update here
        }
    }
}
