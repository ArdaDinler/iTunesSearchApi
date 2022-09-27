//
//  ErrorModel.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import Foundation

enum ErrorModel: Error {
    case network(string: String)
    case parse(string: String)
    case other(string: String)
}
