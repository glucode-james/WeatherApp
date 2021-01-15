//
//  UserDefaultsModelTests.swift
//  WeatherAppTests
//

import XCTest
@testable import WeatherApp

class UserDefaultsModelTests: XCTestCase {

    private let testCity1 = City(city: "Strand", country: "South Africa", latitude: "-33.917", longitude: "18.417")
    private let testCity2 = City(city: "Pretoria", country: "South Africa", latitude: "-25.747", longitude: "28.188")
    private let testCity3 = City(city: "Edinburgh", country: "Scotland", latitude: "55.949", longitude: "-3.163")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveSelectedCity() throws {
        UserDefaultsModel.getInstance().saveSelected(city: testCity1)

        let savedCity = UserDefaultsModel.getInstance().selectedCity()

        XCTAssertNotNil(savedCity)
        XCTAssertEqual(savedCity, testCity1)
    }

    func testSaveCities()  throws {
        UserDefaultsModel.getInstance().save(cities: [testCity1, testCity2])

        let savedCities = UserDefaultsModel.getInstance().cities()

        XCTAssertEqual(savedCities.count, 2)
        XCTAssertEqual(savedCities[0], testCity1)
        XCTAssertEqual(savedCities[1], testCity2)
    }

    func testSaveCitiesOverwrite()  throws {
        UserDefaultsModel.getInstance().save(cities: [testCity1, testCity2])

        UserDefaultsModel.getInstance().save(cities: [testCity3])

        let savedCities = UserDefaultsModel.getInstance().cities()

        XCTAssertEqual(savedCities.count, 1)
        XCTAssertEqual(savedCities[0], testCity3)
    }

}
