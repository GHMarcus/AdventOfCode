//
//  Day_23.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/23

import Foundation

// Note: Part 2 runs about 2h

enum Day_23_2023: Solvable {
    static var day: Input.Day = .Day_23
    static var year: Input.Year = .Year_2023
    
    struct Point: Hashable {
        let x: Int
        let y: Int
        
        var description: String { "(\(x),\(y))" }
    }
    
    struct Edge {
        let to: Point
        let length: Int
    }
    
    enum Direction: String {
        case up = "^", down = "v", left = "<", right = ">"
        
        var opposite: Direction {
            switch self {
            case .up: return .down
            case .down: return .up
            case .left: return .right
            case .right: return .left
            }
        }
        
        func getNext(for point: Point) -> Point {
            switch self {
            case .up: return Point(x: point.x, y: point.y - 1)
            case .down: return Point(x: point.x, y: point.y + 1)
            case .left: return Point(x: point.x - 1, y: point.y)
            case .right: return Point(x: point.x + 1, y: point.y)
            }
        }
    }
    
    struct StepsKey: Hashable {
        let point: Point
        let dir: Direction
        
        var description: String { "(\(point.description), \(dir.rawValue))" }
    }
    
    static func convert(input: [[Character]]) -> [[Character]] {
        input
    }

    static func solvePart1(input: [[Character]]) -> String {
        let start = Point(x: 1, y: 0)
        let goal  = Point(x: input[0].count - 2, y: input.count - 1)

        let longestPath = longestPath(start: start, goal: goal, preComputed: preComputeSteps(for: input))
        return "\(longestPath)"
    }

    static func solvePart2(input: [[Character]]) -> String {
        let start = Point(x: 1, y: 0)
        let goal  = Point(x: input[0].count - 2, y: input.count - 1)
        
        let longestPath = longestPath(start: start, goal: goal, preComputed: preComputeSteps(for: input, isPart2: true))
        return "\(longestPath)"
    }
    
    static func stepAllowed(pos: Point, dir: Direction, maze: [[Character]], isPart2: Bool) -> Bool {
        let next = maze[pos.y][pos.x]
        
        if isPart2 {
            if next == "#" { return false }
            return true
        } else {
            if next == "." { return true }
            if next == ">" && dir == .right { return true }
            if next == "<" && dir == .left { return true }
            if next == "^" && dir == .up { return true }
            if next == "v" && dir == .down { return true }
            return false
        }
    }
    
    static func preComputeSteps(for input: [[Character]], isPart2: Bool = false) -> [StepsKey: [StepsKey]] {
        let directions: [Direction] = [.left, .right, .up, .down]
        
        var preComputed: [StepsKey: [StepsKey]] = [:]
        
        for y in 0..<input.count {
            for x in 0..<input[0].count {
                guard input[y][x] != "#" else { continue }
                let pos = Point(x: x, y: y)
                for cameDir in directions {
                    let cameKey = StepsKey(point: pos, dir: cameDir)
                    var neighbors: [StepsKey] = []
                    for goDir in directions.filter({ cameDir.opposite != $0 }) {
                        let next = goDir.getNext(for: pos)
                        let goKey = StepsKey(point: next, dir: goDir)
                        
                        if next.x >= 0, next.x < input[0].count,
                           next.y >= 0, next.y < input.count,
                           stepAllowed(pos: next, dir: goDir, maze: input, isPart2: isPart2) {
                            neighbors.append(goKey)
                        }
                          
                    }
                    preComputed[cameKey] = neighbors
                }
            }
        }
        
        return preComputed
    }
    
    static func longestPath(start: Point, goal: Point, preComputed: [StepsKey: [StepsKey]]) -> Int {
        
        var maxLength = -1
        var stack: [(StepsKey, Int, Set<Point>)] = [(StepsKey(point: start, dir: .down), 0, [start])]
        
        while var (key, length, visited) = stack.popLast() {
            if key.point == goal {
                maxLength = max(maxLength, length)
                continue
            }
            
            for n in preComputed[key]! {
                if !visited.contains(n.point) {
                    visited.insert(n.point)
                    stack.append((n, length + 1, visited))
                }
            }
        }
        
        return maxLength
    }
}
