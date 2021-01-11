//
//  UserDefaultsModelTests.swift
//  WeatherAppTests
//
//  Created by James Sinclair on 2021/01/11.
//

import XCTest
@testable import WeatherApp

class UserDefaultsModelTests: XCTestCase {

    private let testCity1 = City(name: "Strand", country: "South Africa")
    private let testCity2 = City(name: "Pretoria", country: "South Africa")
    private let testCity3 = City(name: "Edinburgh", country: "Scotland")

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
