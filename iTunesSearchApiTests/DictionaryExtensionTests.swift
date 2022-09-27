//
//  DictionaryExtensionTests.swift
//  iTunesSearchApiTests
//
//  Created by Arda Dinler on 27.09.2022.
//

import XCTest

class DictionaryExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDictHeaderWhenInputEmpty() {
        let emptyStringDict: [String:String] = ["":""]
        XCTAssertNotNil(emptyStringDict.toHeader())
    }

}
