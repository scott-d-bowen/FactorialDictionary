//
//  FactorialDictionary.swift
//  FactorialDictionary
//
//  Created by Scott D. Bowen on 30/8/21.
//

import Foundation
import BigInt

actor FactoralDictionary {
    
    var cachedFactorials: [UInt16 : BigUInt] = [:]
    
    func calculateFactorial(_ n: UInt16) -> BigUInt {
        if let factorial = cachedFactorials[n] {
            return factorial
        } else {
            if (n > 1) {
                let cachedFactorial = (1 ... n).map { BigUInt($0) }.reduce(BigUInt(1), *)
                cachedFactorials[n] = cachedFactorial
                return cachedFactorial
            } else { // if (n == 1){
                return 1        // TODO: Test this case out more.
            }
        }
    }
    nonisolated func calculateFactorialUncached(_ n: UInt16) -> BigUInt {
        if (n > 1) {
            return (1 ... n).map { BigUInt($0) }.reduce(BigUInt(1), *)
        } else { // if (n == 1){
            return 1        // TODO: Test this case out more.
        }
    }
    func cacheGivenFactorial(n: UInt16, factorial: BigUInt) {
        cachedFactorials[n] = factorial
    }
}

actor DividedFactorial {
    let larger: BigUInt
    let smaller: BigUInt
    let result: BigUInt
    
    init(larger: BigUInt, smaller: BigUInt) {
        self.larger = larger
        self.smaller = smaller
        self.result = larger / smaller
    }
}
