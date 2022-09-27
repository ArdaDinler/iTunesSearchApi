//
//  RequestServiceTests.swift
//  iTunesSearchApiTests
//
//  Created by Arda Dinler on 27.09.2022.
//

import XCTest

class RequestServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURL() {
        let query = "Arda"
        let url = "https://itunes.apple.com/"
        let path = "search?term=\(query)&media=software&entity=software"
        guard let requestURL = URL(string: "\(url)\(path)") else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(requestURL, URL(string: "https://itunes.apple.com/search?term=\(query)&media=software&entity=software"))
        XCTAssertNotEqual(requestURL, URL(string: "https://itunes.apple.com/search?term=&media=software&entity=software"))
    }

}
