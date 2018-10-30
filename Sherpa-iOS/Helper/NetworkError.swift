//
//  NetworkError.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
enum NetworkError: Error {
    case noConnection
    case noDataReturned
    case dataNotDecodable
    case unauthorized
    case unknown
    case internalServerError
    case incorrectParameters
    case forwarded(Error)
    case forwardedString(errorString: String)
    case jsonConversionFailure
    case invalidUrl
    case imageDataFailure
}
