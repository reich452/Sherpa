//
//  NetworkError.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
enum NetworkError: Error {
    case authentication
    case badRequest
    case dataNotDecodable
    case encodingFailure(Error)
    case forwarded(Error)
    case forwardedString(errorString: String)
    case jsonConversionFailure
    case imageDataFailure
    case internalServerError
    case incorrectParameters
    case invalidUrl
    case noConnection
    case noDataReturned
    case outdated
    case unauthorized
    case unknown
}
