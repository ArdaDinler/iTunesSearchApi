//
//  RequestService.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import Foundation
import Alamofire

struct RequestService {

    static func get(path: String,
                    params: [String: String]?,
                    headers: [String: String]?,
                    success: @escaping (Data) -> Void,
                    failure: @escaping (ErrorModel) -> Void) {

        stopAllSessions()

        guard let requestURL = URL(string: "\(Constants.iTunes.baseURL)\(path)") else {
            failure(ErrorModel.other(string: "URL encoding error."))
            return
        }

        AF.request(requestURL,
                   method: .get,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers?.toHeader()).responseData { (data) in

            guard let responseData = data.value else {
                failure(ErrorModel.parse(string: "Data parse error."))
                return
            }

            guard data.response?.statusCode == 200  else {
                failure(ErrorModel.network(string: "Connection error."))
                return
            }
            success(responseData)
        }
    }

    static func stopAllSessions() {
        AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
}
