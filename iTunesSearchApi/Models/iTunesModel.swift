//
//  iTunesModel.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import Foundation

typealias Model = ResponseModel.Model

struct ResponseModel: Codable {
    struct Model: Codable {
        let screenshotUrls: [String]?
    }

    let resultCount: Int
    let results: [Model]?

}
