//
//  Location.swift
//  day12
//
//  Created by Timothy Wood on 12/11/22.
//

import Foundation

struct Location2D : Hashable {
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    init(pair: (Int,Int)) {
        self.x = pair.0
        self.y = pair.1
    }

    func manhattanDistance(to other: Self) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }

    static func +(left: Self, right: Self) -> Self {
        return Self(x: left.x + right.x, y: left.y + right.y)
    }
    static func -(left: Self, right: Self) -> Self {
        return Self(x: left.x - right.x, y: left.y - right.y)
    }
    static func +=(left: inout Self, right: Self) {
        left = Self(x: left.x + right.x, y: left.y + right.y)
    }
    static func -=(left: inout Self, right: Self) {
        left = Self(x: left.x - right.x, y: left.y - right.y)
    }

    static prefix func -(value: Self) -> Self {
        return Self(x: -value.x, y: -value.y)
    }

    static func *(left: Self, right: Int) -> Self {
        return Self(x: left.x * right, y: left.y * right)
    }
    static func *(left: Int, right: Self) -> Self {
        return Self(x: left * right.x, y: left * right.y)
    }

    static let left = Self(x: -1, y: 0)
    static let right = Self(x: 1, y: 0)
    static let up = Self(x: 0, y: 1)
    static let down = Self(x: 0, y: -1)

    static let zero = Self(x: 0, y: 0)

    static let cardinalDirections = [left, right, up, down]

    static let leftUp = left + up
    static let leftDown = left + down
    static let rightUp = right + up
    static let rightDown = right + down

    static let diagonals = [leftUp, leftDown, rightUp, rightDown]

    static let allDirections = cardinalDirections + diagonals
}

// Requires map locations are ordered with zero,zero at the bottom left
extension Location2D {
    var turnLeft: Location2D {
        switch self {
        case .left:
            return .down
        case .down:
            return .right
        case .right:
            return .up
        case .up:
            return .left
        default:
            fatalError()
        }
    }
    var turnRight: Location2D {
        switch self {
        case .left:
            return .up
        case .down:
            return .left
        case .right:
            return .down
        case .up:
            return .right
        default:
            fatalError()
        }
    }
}
