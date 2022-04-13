//
//  DateFormatter+Extensions.swift
//  Cloud.vs.Fire
//
//  Created by Nick Reichard on 3/13/21.
//  Copyright © 2021 Nick Reichard. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let yearMonthDayFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private static let timestampFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.maximumUnitCount = 1
        return formatter
    }()
    
    static func dateToString(date: Date) -> String {
        return timestampFormatter.string(from: Date().timeIntervalSince(date))!
    }
}
