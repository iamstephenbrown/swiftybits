//  Type Erasure
//
//  Definition:     Hiding an object's real type / implementation details behind a protocol
//
//  Usage:          If you are dealing with a range of objects and want to hide their concrete types

import Foundation

protocol Rollable {
    func roll()
}

class AnyRollable: Rollable {
    private let wrapped: Rollable
    
    init(_ wrapped: Rollable) {
        self.wrapped = wrapped
    }
    
    func roll() {
        wrapped.roll()
    }
}

struct SixSidedDice: Rollable {
    func roll() {
        print(Int.random(in: 1 ... 6))
    }
}

struct TwentySidedDice: Rollable {
    func roll() {
        print(Int.random(in: 1 ... 20))
    }
}

let allDice: [AnyRollable] = [
    AnyRollable(SixSidedDice()),
    AnyRollable(TwentySidedDice())
]

for dice in allDice {
    dice.roll()
}
