//
//  WeatherModelTests.swift
//  WeatherAppTests
//
//  Created by James Sinclair on 2021/01/12.
//

import XCTest
@testable import WeatherApp

class WeatherModelTests: XCTestCase {

    private let testCity1 = City(city: "Cape Town",
                                 country: "South Africa",
                                 latitude: "-33.917",
                                 longitude: "18.417")

    private let testInvalidCity = City(city: "Tolaria",
                                       country: "Dominaria",
                                       latitude: "-1000",
                                       longitude: "1000")

    var weatherModel: WeatherModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherModel = WeatherModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        weatherModel = nil
    }

    func testLoadValidWeather() throws {
        var currentConditionsResult: CurrentConditions?
        var dailyWeatherResult: [DailyWeather]?
        var successResult = false
        var messageResult = "This is a message"

        let expectation = self.expectation(description: "ValidWeatherSearch")

        weatherModel.lookupWeather(for: testCity1,
                                   completion: {(success, message, currentConditions, dailyWeather) in

                                    successResult = success
                                    messageResult = message
                                    currentConditionsResult = currentConditions
                                    dailyWeatherResult = dailyWeather

                                    expectation.fulfill()

                                   })
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(successResult, true)
        XCTAssertEqual(messageResult, "")
        XCTAssertNotNil(currentConditionsResult)
        XCTAssertNotNil(dailyWeatherResult)
        XCTAssertGreaterThan(dailyWeatherResult?.count ?? 0, 0)
    }

    func testLoadInvalidWeather() throws {
        var currentConditionsResult: CurrentConditions?
        var dailyWeatherResult: [DailyWeather]?
        var successResult = true
        var messageResult = ""

        let expectation = self.expectation(description: "InvalidWeatherSearch")

        weatherModel.lookupWeather(for: testInvalidCity,
                                   completion: {(success, message, currentConditions, dailyWeather) in

                                    successResult = success
                                    messageResult = message
                                    currentConditionsResult = currentConditions
                                    dailyWeatherResult = dailyWeather

                                    expectation.fulfill()

                                   })
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertFalse(successResult)
        XCTAssertGreaterThan(messageResult.count, 0)
        XCTAssertNil(currentConditionsResult)
        XCTAssertNil(dailyWeatherResult)
    }

}
