//
//  WebCityViewModelTests.swift
//  WeatherAppTests
//
//  Created by James Sinclair on 2021/01/13.
//

import XCTest
@testable import WeatherApp

class WebCityViewModelTests: XCTestCase, CityViewModelDelegate {

    var webCityViewModel: WebSearchCityViewModel!

    var testExpectation: XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        webCityViewModel = WebSearchCityViewModel()
        webCityViewModel.delegate = self
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        webCityViewModel = nil

        testExpectation = nil
    }

    func testSearchCitiesWithReturn() throws {
        let expectation = self.expectation(description: "SearchCitiesWithReturn")
        testExpectation = expectation

        webCityViewModel.cityViewModel(search: "Cape Town")
        waitForExpectations(timeout: 5, handler: nil)

        // Check that it saved all of them
        XCTAssertEqual(webCityViewModel.cityViewModelCityCount(), 1)
        XCTAssertEqual("Cape Town", webCityViewModel.cityViewModelCity(at: 0)?.areaName[0].value)

    }

    func testSearchCitiesWithInvalidName() throws {
        let expectation = self.expectation(description: "SearchCitiesWithInvalidName")
        testExpectation = expectation

        // This test counts on there not being a city named BLAHBLAHBLAHBLAHBLAH
        webCityViewModel.cityViewModel(search: "BLAHBLAHBLAHBLAHBLAH")
        waitForExpectations(timeout: 5, handler: nil)

        // Check that it saved all of them
        XCTAssertEqual(webCityViewModel.cityViewModelCityCount(), 0)

    }

    func cityViewModel(updated dataSource: CityDataSource, with error: Bool, message: String) {
        testExpectation?.fulfill()
    }

}
