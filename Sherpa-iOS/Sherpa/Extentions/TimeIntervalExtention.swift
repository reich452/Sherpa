//
//  TimeIntervalExtention.swift
//  Sherpa
//
//  Created by Nick Reichard on 2/1/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

extension TimeInterval {
    // MARK: - Computed Type Properties
    internal static var secondsPerDay: Double { return 24 * 60 * 60 }
    internal static var secondsPerHour: Double { return 60 * 60 }
    internal static var secondsPerMinute: Double { return 60 }
    internal static var millisecondsPerSecond: Double { return 1_000 }
    internal static var microsecondsPerSecond: Double { return 1_000 * 1_000 }
    internal static var nanosecondsPerSecond: Double { return 1_000 * 1_000 * 1_000 }
    
    // MARK: - Computed Instance Properties
    /// - Returns: The `TimeInterval` in days.
    var days: Double {
        return self / TimeInterval.secondsPerDay
    }
    
    /// - Returns: The `TimeInterval` in hours.
    var hours: Double {
        return self / TimeInterval.secondsPerHour
    }
    
    /// - Returns: The `TimeInterval` in minutes.
    var minutes: Double {
        return self / TimeInterval.secondsPerMinute
    }
    
    /// - Returns: The `TimeInterval` in seconds.
    var seconds: Double {
        return self
    }
    
    /// - Returns: The `TimeInterval` in milliseconds.
    var milliseconds: Double {
        return self * TimeInterval.millisecondsPerSecond
    }
    
    /// - Returns: The `TimeInterval` in microseconds.
    var microseconds: Double {
        return self * TimeInterval.microsecondsPerSecond
    }
    
    /// - Returns: The `TimeInterval` in nanoseconds.
    var nanoseconds: Double {
        return self * TimeInterval.nanosecondsPerSecond
    }
    
    /// - Returns: The `TimeInterval` in milisconds from a second.
    var totalMilliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    // - Returns: The String format 
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecondTotal)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecondTotal: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }

}
