//
//  IntExtention.swift
//  Sherpa
//
//  Created by Nick Reichard on 2/2/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
    
    var secondsToMS: Double {
        return Double(self) * 1000
    }
}
