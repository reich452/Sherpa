//
//  ServiceProtocol.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/7/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    var baseURL: URL { get }
    var baseImageURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
