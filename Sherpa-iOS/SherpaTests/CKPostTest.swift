//
//  CKPostTest.swift
//  SherpaTests
//
//  Created by Nick Reichard on 2/15/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import XCTest

@testable import Sherpa

class CKPostTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIncreaseCounter() {
        let myTimer = MyTimer()
        myTimer.startTimer()
        let time = myTimer.increaseCounter()
        let counter = myTimer.counter
        print(time)
        print(counter)
    }
  
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testIncreaseCounter()
        }
    }
}
