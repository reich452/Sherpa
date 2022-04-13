//
//  JSONParameterEncoder.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/7/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
 
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailure(error)
        }
    }
}

