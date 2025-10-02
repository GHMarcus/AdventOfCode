//
//  Day_21.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2023/day/21

enum Day_21_2023: Solvable {
    static var day: Input.Day = .Day_21
    static var year: Input.Year = .Year_2023
    static var part1Positions: Set<Tile> = []
    
    static func convert(input: [[Character]]) -> [[Character]] {
        input
    }

    struct Pos: Hashable {
        let x: Int
        let y: Int
    }
    
    struct Tile: Hashable {
        let pos: Pos
        let distanceToMiddle: Int
    }
    
    static func solvePart1(input: [[Character]]) -> String {
        let steps = 64
        // This works because the map.count is odd so we get the index of the middle one
        let start = Pos(x: input[0].count / 2, y: input.count / 2)
        
        var positions: Set<Tile> = []
        for x in 0..<input[0].count {
            for y in 0..<input.count {
                guard input[y][x] == "." else { continue }
                guard !positions.contains(where: { $0.pos.x == x && $0.pos.y == y }) else { continue }
                let path = aStar(
                    start: start,
                    goal: { $0.x == x && $0.y == y },
                    neighbors: { getNeighbors(of: $0, in: input) }
                )
                
                if let path = path, !path.isEmpty {
                    for (index, pos) in path.enumerated() {
                        positions.insert(Tile(pos: pos, distanceToMiddle: index))
                    }
                }
            }
        }
        part1Positions = positions
        let reachablePositions = positions.filter { $0.distanceToMiddle <= steps && $0.distanceToMiddle.isEven }
        return "\(reachablePositions.count)"
    }

    static func solvePart2(input: [[Character]]) -> String {
        // Solved the geometric way, with special thanks to this github wiki entry
        // https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21
        let steps = 26501365
        let distanceFromStartToCorner = (input.count) / 2
        let n = (steps - distanceFromStartToCorner) / (input.count)
        
        let oddTilesReachable = part1Positions.filter{ $0.distanceToMiddle.isOdd }.count
        let evenTilesReachable = part1Positions.filter{ $0.distanceToMiddle.isEven }.count
        
        let oddCornerTilesReachable = part1Positions.filter{ $0.distanceToMiddle > distanceFromStartToCorner && $0.distanceToMiddle.isOdd }.count
        let evenCornerTilesReachable = part1Positions.filter{ $0.distanceToMiddle > distanceFromStartToCorner && $0.distanceToMiddle.isEven }.count
        
        let total: Int
        
        if steps.isEven {
            total = ((n + 1) * (n + 1)) * evenTilesReachable + (n * n) * oddTilesReachable - (n + 1) * evenCornerTilesReachable + n * oddCornerTilesReachable
        } else {
            total = ((n + 1) * (n + 1)) * oddTilesReachable + (n * n) * evenTilesReachable - (n + 1) * oddCornerTilesReachable + n * evenCornerTilesReachable
        }
        
        return "\(total)"
    }
    
    static func getNeighbors(of position: Pos, in map: [[Character]]) -> [Pos] {
        return [
            Pos(x: position.x + 1, y: position.y),
            Pos(x: position.x - 1, y: position.y),
            Pos(x: position.x, y: position.y + 1),
            Pos(x: position.x, y: position.y - 1)
        ].filter {
            $0.x >= 0 && $0.x < map[0].count && $0.y >= 0 && $0.y < map.count
        }.filter {
            map[$0.y][$0.x] == "."
        }
    }
}
