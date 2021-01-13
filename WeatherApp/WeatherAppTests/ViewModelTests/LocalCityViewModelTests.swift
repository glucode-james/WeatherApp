//
//  CityViewModelTests.swift
//  WeatherAppTests
//
//  Created by James Sinclair on 2021/01/12.
//

import XCTest
@testable import WeatherApp

class LocalCityViewModelTests: XCTestCase, CityViewModelDelegate {

    private let testCity1 = City(city: "Strand", country: "South Africa", latitude: "-33.917", longitude: "18.417")
    private let testCity2 = City(city: "Pretoria", country: "South Africa", latitude: "-25.747", longitude: "28.188")
    private let testCity3 = City(city: "Edinburgh", country: "Scotland", latitude: "55.949", longitude: "-3.163")
    private let testCity4 = City(city: "Tolaria", country: "Dominaria", latitude: "-1000", longitude: "1000")

    var localCityViewModel: LocalSearchCityViewModel!

    var testExpectation: XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        localCityViewModel = LocalSearchCityViewModel()
        localCityViewModel.delegate = self

        // Clear any city data currently in the user defaults
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.cities.rawValue)
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.selectedCity.rawValue)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        localCityViewModel = nil

        testExpectation = nil

        // Clear any city data currently in the user defaults
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.cities.rawValue)
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.selectedCity.rawValue)
    }

    func testSearchCitiesBlank() throws {
        // First add some test cities
        localCityViewModel.setCurrent(city: testCity1)
        localCityViewModel.setCurrent(city: testCity2)
        localCityViewModel.setCurrent(city: testCity3)
        localCityViewModel.setCurrent(city: testCity4)

        // then do a search with a blank string. It should return all of them
        let expectation = self.expectation(description: "SearchCitiesBlank")
        testExpectation = expectation

        localCityViewModel.cityViewModel(search: "")
        waitForExpectations(timeout: 1, handler: nil)

        // Check that it saved all of them
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 4)
        // Check that they were sorted
        // The order should be alphabetical, on city name, so 3, 2, 1, 4
        XCTAssertEqual(testCity3, localCityViewModel.cityViewModelCity(at: 0))
        XCTAssertEqual(testCity2, localCityViewModel.cityViewModelCity(at: 1))
        XCTAssertEqual(testCity1, localCityViewModel.cityViewModelCity(at: 2))
        XCTAssertEqual(testCity4, localCityViewModel.cityViewModelCity(at: 3))
    }

    func testSearchCitiesValue() throws {
        // First add some test cities
        localCityViewModel.setCurrent(city: testCity1)
        localCityViewModel.setCurrent(city: testCity2)
        localCityViewModel.setCurrent(city: testCity3)
        localCityViewModel.setCurrent(city: testCity4)

        // then do a search with a blank string. It should return all of them
        testExpectation = self.expectation(description: "SearchCitiesValue1")
        localCityViewModel.cityViewModel(search: "a")
        waitForExpectations(timeout: 1, handler: nil)
        // 3 cities contain the search value
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 3)

        testExpectation = self.expectation(description: "SearchCitiesValue2")
        localCityViewModel.cityViewModel(search: "o")
        waitForExpectations(timeout: 1, handler: nil)
        // 2 cities contain the search value
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 2)

        testExpectation = self.expectation(description: "SearchCitiesValue3")
        localCityViewModel.cityViewModel(search: "Pretoria")
        waitForExpectations(timeout: 1, handler: nil)
        // 2 cities contain the search value
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 1)
        XCTAssertEqual(testCity2, localCityViewModel.cityViewModelCity(at: 0))

        // Test that the search is NOT case sensitive
        testExpectation = self.expectation(description: "SearchCitiesValue4")
        localCityViewModel.cityViewModel(search: "pretoria")
        waitForExpectations(timeout: 1, handler: nil)
        // 2 cities contain the search value
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 1)
        XCTAssertEqual(testCity2, localCityViewModel.cityViewModelCity(at: 0))
    }

    func testSaveCities() throws {
        // First test 0 and nil when the list should be empty
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 0)
        XCTAssertNil(localCityViewModel.cityViewModelCity(at: 0))

        // Then add a city
        localCityViewModel.setCurrent(city: testCity1)

        // check that it is saved, the view model's list must be refreshed
        testExpectation = self.expectation(description: "SaveCities1")
        localCityViewModel.cityViewModel(search: "")
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 1)
        XCTAssertEqual(localCityViewModel.cityViewModelCity(at: 0), testCity1)

        // then try add it again, test that it isnt added again
        testExpectation = self.expectation(description: "SaveCities2")
        localCityViewModel.cityViewModel(search: "")
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 1)
        XCTAssertEqual(localCityViewModel.cityViewModelCity(at: 0), testCity1)

        // then add a new one, and check that it is saved
        localCityViewModel.setCurrent(city: testCity2)
        testExpectation = self.expectation(description: "SaveCities3")
        localCityViewModel.cityViewModel(search: "")
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 2)
    }

    func testDeleteLocalCity() throws {
        // First add some test cities
        localCityViewModel.setCurrent(city: testCity1)
        localCityViewModel.setCurrent(city: testCity2)
        localCityViewModel.setCurrent(city: testCity3)
        localCityViewModel.setCurrent(city: testCity4)

        // then do a search with a blank string. It should return all of them
        let expectation = self.expectation(description: "DeleteLocalCity")
        testExpectation = expectation

        localCityViewModel.cityViewModel(search: "")
        waitForExpectations(timeout: 1, handler: nil)

        // Check that it saved all of them
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 4)

        // Remove a city
        localCityViewModel.deleteSavedCity(at: 1)

        // Check that the city was removed from the view model list
        XCTAssertEqual(localCityViewModel.cityViewModelCityCount(), 3)
        // And the user defaults
        XCTAssertEqual(UserDefaultsModel.getInstance().cities().count, 3)
    }

    /* This is actually unnecessary for the local search as it doesnt have any asynchronous calls.
     However, this more closely imitates the functionality of the app, so I am leaving it in. */
    func cityViewModel(updated dataSource: CityDataSource, with error: Bool, message: String) {
        testExpectation?.fulfill()
    }

}
