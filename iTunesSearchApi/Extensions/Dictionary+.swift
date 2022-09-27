//
//  Dictionary+.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import Foundation
import Alamofire

extension Dictionary where Key == String, Value == String {
    func toHeader() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        for (key, value) in self  {
            headers.add(name: key, value: value)
        }
        return headers
    }
}
