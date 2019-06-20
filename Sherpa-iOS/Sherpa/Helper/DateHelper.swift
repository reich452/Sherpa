//
//  DateHelper.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/19/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    private init() {}
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private lazy var timestampFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.maximumUnitCount = 1
        return formatter
    }()
    
    func dateToString(date: Date) -> String {
        return timestampFormatter.string(from: Date().timeIntervalSince(date))!
    }
    
}
