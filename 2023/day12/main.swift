//
//  main.swift
//  day12
//
//  Created by Timothy Wood on 12/11/23.
//

import Foundation

let lines = Input.lines()

enum Condition {
    case unknown
    case operational
    case damaged

    init(character: Character) {
        switch character {
        case "?":
            self = .unknown
        case ".":
            self = .operational
        case "#":
            self = .damaged
        default:
            fatalError()
        }
    }
}

// Passing in nextCondition allows for it to be '.' or '#' instead of '?'
func pack(conditions: [Condition], conditionIndex: Int, nextCondition: Condition, damagedLengths: [Int], damageIndex: Int) -> Int {
    // Recursion shouldn't change the total length of the possible pending output and remaining conditions
    //assert(prefix.count + conditions.count == length)

    //print("\(prefix) -- \((conditions.map { String($0.rawValue) }).joined()) \(damagedLengths)")

    if conditionIndex >= conditions.count {
        if damageIndex >= damagedLengths.count {
            //print("\(indent(prefix.count * 2 + 1))at end -> 1")
            return 1
        } else {
            //print("\(indent(prefix.count * 2 + 1))expecting more damage -> 0")
            return 0
        }
    }

    // If we are out of damages but still have conditions, there exactly one match if all the remaining conditions are not damage, otherwise zero
    if damageIndex >= damagedLengths.count {
        for nextConditionIndex in conditionIndex..<conditions.count {
            if conditions[nextConditionIndex] == .damaged {
                return 0
            }
        }
        return 1
    }

    /*
    let totalDamageLeft = damagedLengths.reduce(0, { $0 + $1 })
    let possibleDamageLeft = conditions.reduce(0, { $0 + ($1 == .operational ? 0 : 1) })
    // maybe count the guaranteed damage left and use it as a lower bound to continue
    if totalDamageLeft > possibleDamageLeft {
        return 0
    }
     */

    switch nextCondition {
    case .operational:
        // Can't pack any damaged length into an operational spot
        if conditionIndex + 1 >= conditions.count {
            // The checks above would have caught the case that we'd used up all the damage lengths
            return 0
        }
        return pack(conditions: conditions, conditionIndex: conditionIndex + 1, nextCondition: conditions[conditionIndex + 1], damagedLengths: damagedLengths, damageIndex: damageIndex)
    case .damaged:
        // If we have a definitely (or provisionally assumed) damaged, then we need to have a string of damage matching the given length here and then a separator or the end of the conditions
        if damageIndex >= damagedLengths.count {
            //print("\(indent(prefix.count * 2 + 1))Have damage in the conditions, but no lengths left -> 0")
            return 0
        }
        let firstLength = damagedLengths[damageIndex]

        var remainingConditionIndex = conditionIndex + 1 // first one is the one we just hit
        var remainingLength = firstLength - 1

        // Consume any remaining required damage length
        while remainingLength > 0 {
            if remainingConditionIndex >= conditions.count {
                //print("\(indent(prefix.count * 2 + 1))XXX remaining damage length of \(remainingLength), but ran out of conditions")
                return 0
            }
            let next = conditions[remainingConditionIndex]
            guard next != .operational else {
                //print("\(indent(prefix.count * 2 + 1))XXX remaining damage length of \(remainingLength), but next is \(next)")
                return 0
            }

            remainingConditionIndex += 1
            remainingLength -= 1
        }

        // Now, need a separator or the end of conditions

        if remainingConditionIndex >= conditions.count {
            // No trailing separator, but the end of the conditions is an implicit separator. Recurse to handle the case there are more damaged lengths
            if damageIndex >= damagedLengths.count {
                // Used up all the damage lengths too. Match.
                return 1
            } else {
                // More damages than conditions
                return 0
            }
        }
        let separator = conditions[remainingConditionIndex]

        if separator != .damaged {
            remainingConditionIndex += 1

            if remainingConditionIndex >= conditions.count {
                if damageIndex + 1 >= damagedLengths.count {
                    // Used up the last damage length. Match.
                    return 1
                } else {
                    // Out of conditions, have more damage
                    return 0
                }
            }
            return pack(conditions: conditions, conditionIndex: remainingConditionIndex, nextCondition: conditions[remainingConditionIndex], damagedLengths: damagedLengths, damageIndex: damageIndex + 1)
        } else {
            //print("\(indent(prefix.count * 2 + 1))XXX need a separator after damage but next is \(separator) -> 0")
            return 0
        }
    case .unknown:
        // Can either assume this spot is damaged or not
        let damagedCount = pack(conditions: conditions, conditionIndex: conditionIndex, nextCondition: .damaged, damagedLengths: damagedLengths, damageIndex: damageIndex)
        let undamagedCount = pack(conditions: conditions, conditionIndex: conditionIndex, nextCondition: .operational, damagedLengths: damagedLengths, damageIndex: damageIndex)

        return undamagedCount + damagedCount
    }

}

do {
    var result = 0

    for line in lines {
        let components = line.split(separator: " ")
        let conditions = components[0].map { (ch:Character) -> Condition in Condition(character: ch) }
        let damagedLengths = String(components[1]).numbers(separatedBy: CharacterSet(charactersIn: ","))

        let count = pack(conditions: conditions, conditionIndex: 0, nextCondition: conditions[0], damagedLengths: damagedLengths, damageIndex: 0)
        print("~~~~ \(line) \(count):")
        //    options.forEach { print($0) }
        //    print("~~~~")

        result += count
    }

    print("\(result)")
    //assert(result == 7705) // part 1
}

do {
    var result = 0

    for line in lines {
        let components = line.split(separator: " ")
        let conditions = components[0].map { (ch:Character) -> Condition in Condition(character: ch) }
        let damagedLengths = String(components[1]).numbers(separatedBy: CharacterSet(charactersIn: ","))

        let repeatedConditions = conditions + [.unknown] + conditions + [.unknown] + conditions + [.unknown] + conditions + [.unknown] + conditions
        let repeatedLengths = damagedLengths + damagedLengths + damagedLengths + damagedLengths + damagedLengths

        let count = pack(conditions: repeatedConditions, conditionIndex: 0, nextCondition: repeatedConditions[0], damagedLengths: repeatedLengths, damageIndex: 0)

        print("~~~~ \(line) \(count):")
        //    options.forEach { print($0) }
        //    print("~~~~")

        result += count
    }

    print("\(result)")
}