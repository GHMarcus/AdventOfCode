//
//  Day_6.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/6

enum Direction {
    case up
    case down
    case left
    case right
    
    var turn: Direction {
        switch self {
        case .up: return .right
        case .down: return .left
        case .left: return .up
        case .right: return .down
        }
    }
}

struct Position: Hashable {
    let x: Int
    let y: Int
    var dir: Direction
}

// Took 20.15485906600952 seconds

enum Day_6_2024: Solvable {
    static var day: Input.Day = .Day_6
    static var year: Input.Year = .Year_2024

    static func convert(input: [String]) -> (map: [[Character]], start: Position) {
        var map = [[Character]]()
        var start: Position = Position(x: 0, y: 0, dir: .up)
        for (index, line) in input.enumerated() {
            map.append(Array(line))
            if line.contains("^") {
                start = Position(
                    x: line.distance(from: line.startIndex, to: line.firstIndex(of: "^")!),
                    y: index,
                    dir: .up
                )
            }
        }
        
        return (map: map, start: start)
    }

    static func solvePart1(input: (map: [[Character]], start: Position)) -> String {
        
        var guardPosition: Position = input.start
        var visitedPositions: Set<Position> = [guardPosition]
        
        while guardPosition.y < input.map.count && guardPosition.y >= 0 && guardPosition.x < input.map[0].count && guardPosition.x >= 0 {
            
            var nextPosition: Position
            switch guardPosition.dir {
            case .up:
                nextPosition = Position(x: guardPosition.x, y: guardPosition.y - 1, dir: guardPosition.dir)
            case .down:
                nextPosition = Position(x: guardPosition.x, y: guardPosition.y + 1, dir: guardPosition.dir)
            case .left:
                nextPosition = Position(x: guardPosition.x - 1, y: guardPosition.y, dir: guardPosition.dir)
            case .right:
                nextPosition = Position(x: guardPosition.x + 1, y: guardPosition.y, dir: guardPosition.dir)
            }
            
            if nextPosition.y >= input.map.count || nextPosition.y < 0 || nextPosition.x >= input.map[0].count || nextPosition.x < 0 {
                break
            }
            
            if input.map[nextPosition.y][nextPosition.x] == "#" {
                guardPosition.dir = guardPosition.dir.turn
            } else {
                guardPosition = nextPosition
                visitedPositions.insert(nextPosition)
            }
        }
        
        return "\(visitedPositions.count)"
    }

    static func solvePart2(input: (map: [[Character]], start: Position)) -> String {
        
        var blockingPositions: Set<Position> = []
        
        for y in 0..<input.map.count {
            for x in 0..<input.map[0].count {
                
                if y == input.start.y && x == input.start.x { continue }
                
                var map = input.map
                map[y][x] = "#"
                var guardPosition: Position = input.start
                var visitedPositions: Set<Position> = [guardPosition]
                var isBlocking: Bool = false
                
                while guardPosition.y < map.count && guardPosition.y >= 0 && guardPosition.x < map[0].count && guardPosition.x >= 0 {
                    
                    var nextPosition: Position
                    switch guardPosition.dir {
                    case .up:
                        nextPosition = Position(x: guardPosition.x, y: guardPosition.y - 1, dir: guardPosition.dir)
                    case .down:
                        nextPosition = Position(x: guardPosition.x, y: guardPosition.y + 1, dir: guardPosition.dir)
                    case .left:
                        nextPosition = Position(x: guardPosition.x - 1, y: guardPosition.y, dir: guardPosition.dir)
                    case .right:
                        nextPosition = Position(x: guardPosition.x + 1, y: guardPosition.y, dir: guardPosition.dir)
                    }
                    
                    if nextPosition.y >= map.count || nextPosition.y < 0 || nextPosition.x >= map[0].count || nextPosition.x < 0 {
                        break
                    }
                    
                    if map[nextPosition.y][nextPosition.x] == "#" {
                        guardPosition.dir = guardPosition.dir.turn
                    } else {
                        guardPosition = nextPosition
                        let inserted = visitedPositions.insert(nextPosition).inserted
                        if !inserted {
                            isBlocking = true
                            break
                        }
                    }
                }
                
                if isBlocking {
                    blockingPositions.insert(Position(x: x, y: y, dir: .up))
                }
                
            }
        }
        
        return "\(blockingPositions.count)"
    }
}
