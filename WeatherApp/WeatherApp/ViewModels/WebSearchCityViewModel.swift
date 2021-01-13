//
//  CityViewModel.swift
//  WeatherApp
//

import Foundation

class WebSearchCityViewModel: BaseCityViewModel {

    private let cityModel: CityModel

    override init() {
        self.cityModel = CityModel()
    }

    override func cityViewModel(search value: String) {
        cityModel.doCitySearch(search: value, completion: { (success, message, cities) in

            self.cities = cities

            self.delegate?.cityViewModel(updated: self, with: success, message: message)
        })
    }
}
