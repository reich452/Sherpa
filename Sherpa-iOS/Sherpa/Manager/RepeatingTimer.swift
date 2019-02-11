//
//  RepeatingTimer.swift
//  Sherpa
//
//  Created by Nick Reichard on 1/31/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

class RepeatingTimer {
    
    let timeInterval: TimeInterval
    var counter = 0.0
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    // MARK: - Private
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    // MARK: - Public
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    
    @objc func runTimer() -> String {
        counter += 0.1
        let flooredCounter = Int(floor(counter))
        
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "\(second)"
        }
        print("$$$ REPEAT COUNTER TACK \(counter) $$$$")
        let decisecond = String(format: "%.1f", counter).components(separatedBy: ".").last!
        
        return "\(secondString).\(decisecond)"
    }
}
