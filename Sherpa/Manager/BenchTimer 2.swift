//
//  BenchTimer.swift
//  Sherpa
//
//  Created by Nick Reichard on 4/8/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import QuartzCore

public final class BenchTimer {
//    @inline(never) - Apple says to no use inline
    /// returns dt time in seconds
    public static func measureBlock(closure:() -> Void) -> CFTimeInterval {
        let runCount = 100
        var executionTimes = Array<Double>(repeating: 0.0, count: runCount)
        // average 10 runs
        for i in 0..<runCount {
            let startTime = CACurrentMediaTime()
            closure()
            let endTime = CACurrentMediaTime()
            let execTime = endTime - startTime
            executionTimes[i] = execTime
        }
        return (executionTimes.reduce(0, +)) / Double(runCount)
    }
}

public extension CFTimeInterval {
    var formattedTime: String {
        return self >= 1000 ? String(Int(self)) + "s"
            : self >= 1 ? String(format: "%.3gs", self)
            : self >= 1e-3 ? String(format: "%.3gms", self * 1e3)
            : self >= 1e-6 ? String(format: "%.3gµs", self * 1e6)
            : self < 1e-9 ? "0s"
            : String(format: "%.3gns", self * 1e9)
    }
}
