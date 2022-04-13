//
//  MyTimer.swift
//  Sherpa
//
//  Created by Nick Reichard on 2/11/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

protocol MyTimerDelegate: AnyObject {
    func updateTimeLable(counterStr: String)
}

class MyTimer {
    
    // MARK: - Properties
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    var counter = 0.0
    var isRunning = false
    var timer = Timer()
    weak var delegate: MyTimerDelegate?
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
 
    
    // MARK: - Absolute Time
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return duration!
    }
    
    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
    
    @discardableResult func time<Result>(name: StaticString = #function, line: Int = #line, _ f: () -> Result) -> Result {
        let startTime = DispatchTime.now()
        let result = f()
        let endTime = DispatchTime.now()
        let diff = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000 as Double
        debugPrint("\(name) (line \(line)): \(diff) sec")
        return result
    }

    // MARK: - Timer class
    
    func startTimer() {
        if !isRunning {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(increaseCounter), userInfo: nil, repeats: true)
            isRunning = true
        }
    }
    
    @objc func increaseCounter() {
        counter += 0.1
        let flooredCounter = Int(floor(counter))
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "\(second)"
        }
        debugPrint(" +++++ MY counter is \(counter) +++++")
        let deciSecond = String(format: "%.1f", counter).components(separatedBy: ".").last!
        let secondStr = "\(secondString).\(deciSecond)"
        delegate?.updateTimeLable(counterStr: secondStr)
    }
    
    // MARK: - Stop
    
    func stopTimer() {
        timer.invalidate()
        isRunning = false
    }
    
    func resetTimer() {
        timer.invalidate()
        isRunning = false
        counter = 0.0
    }
    
}
