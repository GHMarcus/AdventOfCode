//
//  Day_11.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2017/day/11

// Note: Took 69.1251449584961 seconds
// Could not finde a better way to find the steps then aStar, but due to missing walls the aStar is very slow
// With heuristic: Took 3.7862499952316284 seconds

enum Day_11_2017: Solvable {
    static var day: Input.Day = .Day_11
    static var year: Input.Year = .Year_2017
    
    struct Pos: Hashable {
        let x, y: Int
        let even: Bool
    }
    
    enum Dir: String, CaseIterable {
        case n
        case s
        case ne
        case se
        case sw
        case nw
        
        func getNext(from pos: Pos) -> Pos {
            switch self {
            case .n: return Pos(x: pos.x, y: pos.y - 1, even: pos.even)
            case .s: return Pos(x: pos.x, y: pos.y + 1, even: pos.even)
            case .ne:
                if pos.even {
                    return Pos(x: pos.x, y: pos.y - 1, even: false)
                } else {
                    return Pos(x: pos.x + 1, y: pos.y, even: true)
                }
            case .se:
                if pos.even {
                    return Pos(x: pos.x, y: pos.y, even: false)
                } else {
                    return Pos(x: pos.x + 1, y: pos.y + 1, even: true)
                }
            case .sw:
                if pos.even {
                    return Pos(x: pos.x - 1, y: pos.y, even: false)
                } else {
                    return Pos(x: pos.x, y: pos.y + 1, even: true)
                }
            case .nw:
                if pos.even {
                    return Pos(x: pos.x - 1, y: pos.y - 1, even: false)
                } else {
                    return Pos(x: pos.x, y: pos.y, even: true)
                }
            }
        }
    }
    
    static func convert(input: [String]) -> [Dir] {
        input.first!.components(separatedBy: ",").map{ Dir(rawValue: $0)! }
    }

    static func solvePart1(input: [Dir]) -> String {
        let start = Pos(x: 0, y: 0, even: true)
        var current = start
        for dir in input {
            current = dir.getNext(from: current)
        }
        
        let path = aStar(
            start: current,
            goal: start,
            heuristic: { abs($0.x) + abs($0.y) },
            neighbors: { getNeighbors(of: $0) }
        ) ?? []
        
        return "\(path.count - 1)"
    }

    static func solvePart2(input: [Dir]) -> String {
        let start = Pos(x: 0, y: 0, even: true)
        var current = start
        var furthest = current
        for dir in input {
            current = dir.getNext(from: current)
            if abs(current.x) + abs(current.y) > abs(furthest.x) + abs(furthest.y) {
                furthest = current
            }
        }
        
        let path = aStar(
            start: furthest,
            goal: start,
            heuristic: { abs($0.x) + abs($0.y) },
            neighbors: { getNeighbors(of: $0) }
        ) ?? []
        
        return "\(path.count - 1)"
    }
    
    static func getNeighbors(of pos: Pos) -> [Pos] {
        Dir.allCases.map { $0.getNext(from: pos) }
    }
}
