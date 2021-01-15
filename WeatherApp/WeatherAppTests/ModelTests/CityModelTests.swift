//
//  CityModelTests.swift
//

import XCTest
@testable import WeatherApp

class CityModelTests: XCTestCase {

    private let testCity1 = City(city: "Strand",
                                 country: "South Africa",
                                 latitude: "-33.917",
                                 longitude: "18.417")

    var cityModel: CityModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cityModel = CityModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cityModel = nil
    }

    func testCitySearch() throws {
        var cityResult = [City]()
        var successResult = false
        var messageResult = "This is a message"

        let expectation = self.expectation(description: "CitySearch")

        cityModel.doCitySearch(search: "Cape Town",
                               completion: {(success, message, cities) in

                                successResult = success
                                messageResult = message
                                cityResult.append(contentsOf: cities)

                                expectation.fulfill()
                               })
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(successResult, true)
        XCTAssertEqual(messageResult, "")
        XCTAssertEqual(cityResult.count, 1)
        // XCTAssertEqual(cityResult[0], testCity1)
    }

}
