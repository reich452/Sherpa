//
//  HTTPTask.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/7/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String : String]
public typealias Parameters = [String: Any]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload...etc
}
