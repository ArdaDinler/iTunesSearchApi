//
//  iTunesSearchApiTests.swift
//  iTunesSearchApiTests
//
//  Created by Arda Dinler on 27.09.2022.
//

import XCTest
@testable import iTunesSearchApi

class iTunesSearchApiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeFromEmptyData() {
        guard let _ = FileManager.readJson(forResource: "saple") else {
            XCTAssert(true)
            return
        }
        XCTAssert(false)
    }

    func testDecodeIntoResponseModel() {

        guard let data = FileManager.readJson(forResource: "sample") else {
            XCTAssert(false)
            return
        }

        let response = try? JSONDecoder().decode(ResponseModel.self, from: data)
        XCTAssertEqual(response?.results?.first?.screenshotUrls?.first, "https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/08/43/c0/0843c0c9-394f-5be9-037c-84b464dd8d74/mzl.zkcyclbm.png/392x696bb.png")

    }
}

extension FileManager {
    static func readJson(forResource fileName: String ) -> Data? {
        let bundle = Bundle(for: iTunesSearchApiTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        return nil
    }
}
