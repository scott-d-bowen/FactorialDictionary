//
//  main.swift
//  FactorialDictionary
//
//  Created by Scott D. Bowen on 30/8/21.
//

import Foundation
import BigInt

var GLOBAL_START = Date()
let dispatchGroup = DispatchGroup()

func benchmarkCode(text: String) {
    let value = -GLOBAL_START.timeIntervalSinceNow
    print("\(Int64(value * 1_000_000)) nanoseconds \(text)")
    GLOBAL_START = Date()
}

print("Hello, World!")

var factDict = FactoralDictionary()

Task {
    await withTaskGroup(of: (iter: Int, bitWidth: Int, hash: String, factorial: BigUInt).self) { group in
        for await iterator in ZeroBasedAsyncCounter(howHigh: Int(16384)) {
            group.addTask(priority: .userInitiated, operation: {
                let factorialX = factDict.calculateFactorialUncached(UInt16(iterator))
                return       (iterator,
                              factorialX.bitWidth,
                              String(factorialX.hashValue, radix: 16, uppercase: true),
                              factorialX)
            })
        }
        benchmarkCode(text: "Primary Loop Init.")
        
        for await tuple in group {
            await factDict.cacheGivenFactorial(n: UInt16(tuple.iter), factorial: tuple.factorial)
            // print(tuple.iter, tuple.bitWidth, tuple.hash)
        }
        benchmarkCode(text: "Secondary Loop Init.")
        await group.waitForAll()
        benchmarkCode(text: "Primary and Secondary Loops Complete.")
    }
    await print(factDict.cachedFactorials.count)
    
    // print(factDict.cachedFactorials[UInt16.random(in: 0..<UInt16(factDict.cachedFactorials.count))])
    await withTaskGroup(of: (BigUInt).self) { group in
        for await iterator in ZeroBasedAsyncCounter(howHigh: 42_000_000+1) {
            let rng = await UInt16.random(in: 0..<UInt16(factDict.cachedFactorials.count))
            let x = await factDict.cachedFactorials[rng]
            if (iterator == 42_000_000) {
                print (rng, x!.bitWidth, String(x!.hashValue, radix: 16, uppercase: true))
            }
        }
        await group.waitForAll()
        benchmarkCode(text: "[42,000,000 x Random Accesses]")
    }
}
print("Task Init Called.")


sleep(300)
