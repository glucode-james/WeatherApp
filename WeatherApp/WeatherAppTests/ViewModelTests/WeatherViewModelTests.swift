//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase, WeatherViewModelDelegate {

    private let testCity = City(city: "Pretoria", country: "South Africa", latitude: "-25.747", longitude: "28.188")

    var viewModel: WeatherViewModel!

    var testExpectation: XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WeatherViewModel()
        viewModel.delegate = self

        // Clear any city data currently in the user defaults
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.cities.rawValue)
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.selectedCity.rawValue)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil

        testExpectation = nil

        // Clear any city data currently in the user defaults
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.cities.rawValue)
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.selectedCity.rawValue)
    }

    func testGetCurrentCity() throws {
        // Set a selected city in the UserDefaultsModel
        UserDefaultsModel.getInstance().saveSelected(city: testCity)

        // Test the the view model gets it correctly
        let city = viewModel.getSelectedCity()

        XCTAssertNotNil(city)
        XCTAssertEqual(city, testCity)
    }

    func testCityWeatherLookup() throws {
        UserDefaultsModel.getInstance().saveSelected(city: testCity)

        let expectation = self.expectation(description: "CityWeatherLookup")
        testExpectation = expectation

        viewModel.loadWeatherForSelectedCity()
        waitForExpectations(timeout: 5, handler: nil)

        // Check that all the different data has been populated
        XCTAssertNotNil(viewModel.getCurrentConditions())
        XCTAssertNotNil(viewModel.getDailyWeather(at: 0))
        XCTAssertNotNil(viewModel.getHourlyWeather(at: 0))
        XCTAssertNotNil(viewModel.getHourlyWeather(at: 4))
        XCTAssertNil(viewModel.getHourlyWeather(at: 5))
    }

    func testLatLongWeatherLookup() throws {
        let expectation = self.expectation(description: "LatLongWeatherLookup")
        testExpectation = expectation

        viewModel.loadWeatherFor(lat: testCity.latitude, long: testCity.longitude)
        waitForExpectations(timeout: 5, handler: nil)

        // Check that all the different data has been populated
        XCTAssertNotNil(viewModel.getCurrentConditions())
        XCTAssertNotNil(viewModel.getDailyWeather(at: 0))
        XCTAssertNotNil(viewModel.getHourlyWeather(at: 0))
        XCTAssertNotNil(viewModel.getHourlyWeather(at: 4))
        XCTAssertNil(viewModel.getHourlyWeather(at: 5))
    }

    func weatherViewModel(weatherUpdated weatherViewModel: WeatherViewModel, error: Bool, message: String) {
        testExpectation?.fulfill()
    }
}
