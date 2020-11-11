//  Capture Lists
//
//  Definition:     A Capture List is a list of variables (in square brackets) that we want to capture for a closure. By capturing them, we take their current value, rather than referencing from context.
//

//  Closures are blocks of functionality that can be passed around in your code.
//  They can capture and store references to any variables from the context in which they are defined.

import Foundation

func uncapturedClosure() {
    var number = 0
    
    let closure = {
        print(number)
    }
    
    number += 1
    closure()
}

func capturedClosure() {
    var number = 0
    
    let closure = { [number] in
        print(number)
    }
    
    number += 1
    closure()
}

uncapturedClosure() // will print 1 as we are not capturing the number variable when we create the closure.
capturedClosure() // will print 0 as we capture the state of the number variable.



//  Reference Cycles and Capture Lists
//
//  Definition:     A closure's capture list keeps a strong reference to variables by default. Without specifying the reference type we can run into memory problems.
//
//  Weak:           Weak capture [weak self] does not create a strong reference, so the captured values are not kept alive by the closure, allowing them to be destroyed and making them optional.
//

class Dice {
    func roll() {
        print("Dice roll is \(Int.random(in: 1...6))")
    }
}
typealias RollResult = () -> Void
func rollWeak() -> RollResult {
    let dice = Dice()
    
    let roll = { [weak dice] in
        guard let dice = dice else {
            print("Dice is nil")
            return
        }
        dice.roll()
        return
    }
    
    return roll
}

let rollWeakClosure = rollWeak()
rollWeakClosure() // "Dice is nil". Dice was lost after we left the scope of the function as it was specified as weak


func rollStrong() -> RollResult {
    let dice = Dice()
    
    let roll = { [dice] in
        dice.roll()
    }
    
    return roll
}

let rollStrongClosure = rollStrong()
rollStrongClosure() // "Dice roll is X". The closure keeps a strong reference to the Dice object, meaning it cannot be destroyed even after leaving the scope.


func rollUnowned() -> RollResult {
    let dice = Dice()
    let roll = { [unowned dice] in
        dice.roll()
    }
    
    return roll
}

let rollUnownedClosure = rollUnowned()
rollUnownedClosure() // This will crash as the unowned keyword behaves similarly to weak, however the variable will be implicitly unwrapped.
