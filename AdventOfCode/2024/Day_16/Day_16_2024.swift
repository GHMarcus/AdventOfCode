//
//  Day_16.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/16

enum Day_16_2024: Solvable {
    static var day: Input.Day = .Day_16
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = (map: [[Character]], start: Pos, end: Pos)
    
    enum Direction: Character, Hashable {
        case left = "<"
        case right = ">"
        case up = "^"
        case down = "v"
    }
    struct Seat: Equatable, Hashable {
        var x, y: Int
    }
    struct Pos: Equatable, Hashable {
        var x, y: Int
        var dir: Direction
        
        var next: Pos {
            switch dir {
            case .left:
                Pos(x: x-1, y: y, dir: .left)
            case .right:
                Pos(x: x+1, y: y, dir: .right)
            case .up:
                Pos(x: x, y: y-1, dir: .up)
            case .down:
                Pos(x: x, y: y+1, dir: .down)
            }
        }
        
        func turnClockwise() -> Pos {
            let newDir: Direction
            switch dir {
            case .left: newDir = .up
            case .up: newDir = .right
            case .right: newDir = .down
            case .down: newDir = .left
            }
            return Pos(x: x, y: y, dir: newDir)
        }
        
        func turnCounterClockwise() -> Pos {
            let newDir: Direction
            switch dir {
            case .left: newDir = .down
            case .down: newDir = .right
            case .right: newDir = .up
            case .up: newDir = .left
            }
            return Pos(x: x, y: y, dir: newDir)
        }
        
        func distance(to other: Pos) -> Int {
            abs(x - other.x) + abs(y - other.y)
        }
        
        var desc: String {
            "\(x),\(y)(\(dir))"
        }
    }
    
    static func convert(input: [String]) -> ConvertedInput {
        var start = Pos(x: 0, y: 0, dir: .right)
        var end = Pos(x: 0, y: 0, dir: .right)
        let map = input.map{ Array($0) }
        for y in 0..<map.count {
            for x in 0..<map[0].count {
                if map[y][x] == "S" {
                    start = Pos(x: x, y: y, dir: .right)
                } else if map[y][x] == "E" {
                    end = Pos(x: x, y: y, dir: .right)
                }
            }
        }
        return (map, start, end)
    }
    
    static func solvePart1(input: ConvertedInput) -> String {
        let path = aStar(
            start: input.start,
            goal: { $0.x == input.end.x && $0.y == input.end.y },
            cost: { $0.dir == $1.dir ? 1 : 1000 },
            heuristic: { $0.distance(to: input.end) },
            neighbors: { getNextMove(for: $0, in: input.map) }
        ) ?? []
        
        var coast = 0
        for i in 1..<path.count {
            if path[i].dir == path[i-1].dir {
                coast += 1
            } else {
                coast += 1000
            }
        }
        return "\(coast)"
    }
    
    static func solvePart2(input: ConvertedInput) -> String {
        let paths = aStarAll(
            start: input.start,
            goal: { $0.x == input.end.x && $0.y == input.end.y },
            cost: { $0.dir == $1.dir ? 1 : 1000 },
            heuristic: { $0.distance(to: input.end) },
            neighbors: { getNextMove(for: $0, in: input.map) }
        ) ?? []
        
        var seats: Set<Seat> = []
        for path in paths {
            for pos in path {
                seats.insert(Seat(x: pos.x, y: pos.y))
            }
        }
        
        return "\(seats.count)"
    }
    
    static func getNextMove(for pos: Pos, in map: [[Character]]) -> [Pos] {
        let next = pos.next
        if map[next.y][next.x] == "." || map[next.y][next.x] == "E" || map[next.y][next.x] == "S" {
            return [
                pos.turnClockwise(),
                pos.turnCounterClockwise(),
                next
            ]
        } else {
            return [
                pos.turnClockwise(),
                pos.turnCounterClockwise()
            ]
        }
    }
}
