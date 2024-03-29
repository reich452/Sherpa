//
//  NetworkLogger.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/7/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

enum NetworkLogger {
    
    static func log(request: URLRequest) {
        
        debugPrint("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { debugPrint("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        debugPrint(logOutput)
    }
    
    static func log(response: URLResponse) {
        debugPrint("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        defer { debugPrint("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        let urlStr = response.url?.absoluteString ?? ""
        let encodingName = response.textEncodingName ?? ""
        let mimeType = response.mimeType ?? ""
        
        debugPrint("\n URL: \(urlStr)\n encodingName \(encodingName)\n MIMEtype \(mimeType) ")
        let httpUrlResponse = response as? HTTPURLResponse
        
        if let httpResponse = httpUrlResponse {
            debugPrint("\n\n Response code: \(httpResponse.statusCode)\n\n  all headerFields \(httpResponse.allHeaderFields)\n\n Localized String \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
        }
        
    }
}
