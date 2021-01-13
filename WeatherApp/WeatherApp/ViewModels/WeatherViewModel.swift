//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by James Sinclair on 2021/01/13.
//

import Foundation

protocol WeatherViewModelDelegate: class {

}

class WeatherViewModel {

    weak var delegate: WeatherViewModelDelegate?
}
