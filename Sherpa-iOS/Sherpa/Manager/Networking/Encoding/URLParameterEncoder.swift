//
//  URLParameterEncoder.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/7/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.invalidUrl }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = parameters.compactMap { URLQueryItem(name: $0.0, value: "\($0.1)") }
            
            guard let url = urlComponents.url else {
                fatalError("URL optional is nil")
            }
  
            urlRequest.url = url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
    }
}
