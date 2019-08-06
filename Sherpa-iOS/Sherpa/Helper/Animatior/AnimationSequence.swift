//
//  AnimationSequence.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/5/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

final class AnimationSequence {
    fileprivate var completion: (() -> Void) = {  }
    fileprivate var sequence = [AnimationStep]()
    fileprivate var stepDuration: TimeInterval
    
    init(withStepDuration stepDuration: TimeInterval = 0.0) {
        self.stepDuration = stepDuration
    }
    
    @discardableResult
    func doStep(_ animations: @escaping (() -> Void)) -> Self {
        let step = AnimationStep(withAnimations: animations, duration: stepDuration)
        sequence.append(step)
        
        return self
    }
    
    @discardableResult
    func onCompletion(_ sequenceCompletion: @escaping (() -> Void)) -> Self {
        completion = sequenceCompletion
        
        return self
    }
    
    func execute() {
        executeSteps()
    }
    
    fileprivate func executeSteps() {
        if sequence.isEmpty == false {
            let step = sequence.removeFirst()
            step
                .onCompleted {
                    self.executeSteps()
                }
                .execute()
        } else {
            completion()
        }
    }
}
