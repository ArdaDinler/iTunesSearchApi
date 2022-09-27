//
//  iTunesSearchViewModelTests.swift
//  iTunesSearchApiTests
//
//  Created by Arda Dinler on 27.09.2022.
//

import XCTest
@testable import iTunesSearchApi

class iTunesSearchViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    fileprivate var service : MockService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.service = MockService()
        self.viewModel = ViewModel(service: service)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
        let viewModel = ViewModel()
        XCTAssertNil(viewModel.sections)
    }

    func testAllSectionPictureCountWhenInit() {
        let viewModel = ViewModel()
        XCTAssertEqual(viewModel.getAllSectionPicturesCount(), 0)
    }

    func testAllSectionPictureCountWhenSectionsEmpty() {
        let viewModel = ViewModel()
        viewModel.sections = []
        XCTAssertEqual(viewModel.getAllSectionPicturesCount(), 0)
    }

    func testWhenCreateSectionsHaveFourSections() {
        let viewModel = ViewModel()
        viewModel.createNewSections()
        XCTAssertEqual(viewModel.sections?.count ?? 0, 4)
    }

    func testWhenFirstInitSearchQueryIsEmpty() {
        let viewModel = ViewModel()
        XCTAssertTrue(viewModel.searchQuery.isEmpty)
    }

    func testWhenFirstInitTotalPicturesCountIsZero() {
        let viewModel = ViewModel()
        XCTAssertEqual(viewModel.getAllSectionPicturesCount(), 0)
    }

    func testFetchWithNoService() {
        viewModel.service = nil

        viewModel.search(query: "Arda", success: { (response) in
            XCTAssert(false)
        }) { (error) in
            XCTAssert(true)
        }
    }

    func testFetchImages() {
        viewModel.search(query: "Arda", success: { (response) in
            XCTAssert(true)
        }) { (error) in
            XCTAssert(false)
        }
    }

    func testWhenSearchQueryIsEmptySectionsIsNotNil() {
        let expectation = XCTestExpectation(description: "sections have default sections")
        viewModel.searchQuery = ""
        let asyncWaitDuration = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) {
            // Verify state after
            XCTAssertNotNil(self.viewModel.sections)

            expectation.fulfill()
        }
    }

    func testWhenSearchQueryIsNotEmptySectionsHavePictures() {
        let expectation = XCTestExpectation(description: "sections have 4 section and some section has pictures")
        viewModel.searchQuery = "Arda"
        let asyncWaitDuration = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) {
            // Verify state after
            print("Arda")
            print(self.viewModel.getAllSectionPicturesCount())
            XCTAssertNotEqual(self.viewModel.getAllSectionPicturesCount(), 0)

            expectation.fulfill()
        }
    }

    func testImageSizeCatWhenImage59kbEqualToBelow100kb() {
        let bundle = Bundle.init(for: iTunesSearchApiTests.self)
        guard let image = UIImage(named: "100kb.jpg", in: bundle, with: .none) else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(viewModel.getImageSizeCat(image: image, type: .jpeg), ViewModel.ImageSize.below100KB)
    }

    func testImageSizeCatWhenImage150kbEqualToBelow250kb() {
        let bundle = Bundle.init(for: iTunesSearchApiTests.self)
        guard let image = UIImage(named: "150kb.png", in: bundle, with: .none) else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(viewModel.getImageSizeCat(image: image, type: .png), ViewModel.ImageSize.below250KB)
    }

    func testImageSizeCatWhenImage324kbEqualToBelow500kb() {
        let bundle = Bundle.init(for: iTunesSearchApiTests.self)
        guard let image = UIImage(named: "324kb", in: bundle, with: .none) else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(viewModel.getImageSizeCat(image: image, type: .png), ViewModel.ImageSize.below500KB)
    }

    func testImageSizeCatWhenImage1mbEqualToUpper500kb() {
        let bundle = Bundle.init(for: iTunesSearchApiTests.self)
        guard let image = UIImage(named: "1mb", in: bundle, with: .none) else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(viewModel.getImageSizeCat(image: image, type: .png), ViewModel.ImageSize.upper500KB)
    }
}

class MockService: ServiceProtocol {
    var responseModel: ResponseModel?
    var error: ErrorModel?

    func search(query: String, success: @escaping (ResponseModel) -> Void, failure: @escaping (ErrorModel) -> Void) {
        if let responseModel = responseModel {
            success(responseModel)
        } else {
            failure(ErrorModel.other(string: "Couldn't fetch data."))
        }
    }
}
