//
//  ArrayExtention.swift
//  Sherpa
//
//  Created by Nick Reichard on 2/15/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
// Serial - only one task at a time can access the result variable.
// Seiral - One thread. Only one task at a time can be exicuted
// Seiral vs Concurrent. Tells you that you wheather a que has one or several threads
extension Array {
    ///Specifies an amount of iterations and a block that's called with each iteration. We set the amount of iterations to be the length of the [B] array, which means that the current iteration number, passed into the block, is an index into the array:
    func concurrentMap<B>(_ transform: @escaping (Element) -> B) -> [B] {
        let result = ThreadSafe(Array<B?>(repeating: nil, count: count))
        DispatchQueue.concurrentPerform(iterations: count) { idx in
            let element = self[idx]
            let transformed = transform(element)
            result.atomically {
                $0[idx] = transformed
            }
        }
        return result.value.map { $0! }
    }
}
