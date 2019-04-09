//
//  Protocols.swift
//  Sherpa
//
//  Created by Nick Reichard on 12/16/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation

protocol FetchAndUploadCounter: class {
    func increaseFetchTimer()
    func increaseCkUploadTimer(time: Double)
    func timerCompleted()
    func increaseFbUploadTimer(time: Double)
}

extension FetchAndUploadCounter {
    func increaseFetchTimer() {}
    func increaseCkUploadTimer(time: Double) {}
    func increaseFbUploadTimer(time: Double) {}
}
