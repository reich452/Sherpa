//
//  AnimationStep.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/5/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

final class AnimationStep {
    fileprivate var completed: (() -> Void) = {  }
    fileprivate let animations: (() -> Void)
    fileprivate let duration: TimeInterval
    
    init(withAnimations animations: @escaping (() -> Void), duration: TimeInterval = 0.0) {
        self.animations = animations
        self.duration = duration
    }
    
    func onCompleted(completed: @escaping (() -> Void)) -> Self {
        self.completed = completed
        return self
    }
    
    func execute() {
        UIView.animate(withDuration: duration, animations: animations) { _ in
            self.completed()
        }
    }
}
