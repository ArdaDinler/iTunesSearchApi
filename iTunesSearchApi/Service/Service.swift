//
//  Service.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import Foundation

protocol ServiceProtocol {
    func search(query: String, success: @escaping(_ result: ResponseModel) -> Void, failure: @escaping(_ error: ErrorModel) -> Void)
}

class Service: ServiceProtocol {

    static let shared = Service()

    func search(query: String,
                success: @escaping(_ result: ResponseModel) -> Void,
                failure: @escaping(_ error: ErrorModel) -> Void) {

        NSObject.cancelPreviousPerformRequests(withTarget: self)

        RequestService.get(path: "search?term=\(query)&media=software&entity=software", params: nil, headers: nil, success: { (data) in

            guard let response = try? JSONDecoder().decode(ResponseModel.self, from: data) else {
                failure(ErrorModel.parse(string: "Parsing error."))
                return
            }
            success(response)

        }, failure: { (error) in
            failure(error)
        })
    }
}
