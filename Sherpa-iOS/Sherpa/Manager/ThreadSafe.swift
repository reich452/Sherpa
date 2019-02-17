//
//  ThreadSafe.swift
//  Sherpa
//
//  Created by Nick Reichard on 2/15/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

final class ThreadSafe<A> {
    private var _value: A
    private let queue = DispatchQueue(label: "ThreadSafe")
    init(_ value: A) {
        self._value = value
    }
    
    /// Get
    var value: A {
        return queue.sync { _value }
    }
    /// Set
    func atomically(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
