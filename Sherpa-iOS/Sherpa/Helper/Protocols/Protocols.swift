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
    func increaseUploadTimer() 
    func timerCompleted()
}

extension FetchAndUploadCounter {
    func increaseFetchTimer() {}
    func increaseUploadTimer() {}
}
