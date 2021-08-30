//
//  ZeroBasedAsyncCounter.swift
//  ZeroBasedAsyncCounter
//
//  Created by Scott D. Bowen on 30/8/21.
//

struct ZeroBasedAsyncCounter : AsyncSequence {
    
    typealias Element = Int
    let howHigh: Int

  struct AsyncIterator : AsyncIteratorProtocol {
      
    let howHigh: Int
    var current = 0
      
    mutating func next() async -> Int? {
      // We could use the `Task` API to check for
      // cancellation here and return early.
      guard current < howHigh else {
        return nil
    }

    let result = current
    current += 1
    return result
    }
  }

  func makeAsyncIterator() -> AsyncIterator {
    return AsyncIterator(howHigh: howHigh)
  }
}
