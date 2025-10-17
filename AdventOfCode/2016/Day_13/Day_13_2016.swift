//
//  Day_13.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2016/day/13

enum Day_13_2016: Solvable {
    static var day: Input.Day = .Day_13
    static var year: Input.Year = .Year_2016
    
    typealias Map = [[Character]]

    struct Pos: Hashable {
        let x, y: Int
    }
    
    static func solvePart1(input: [Int]) -> String {
        let favoriteNumber = input.first!
        let start = Pos(x: 1, y: 1)
        let goal = Pos(x: 31, y: 39)
        
        let map = generateMap(with: favoriteNumber, maxX: goal.x + 10, maxY: goal.y + 10)
        
        let path = aStar(start: start, goal: goal, neighbors: { getNeighbors(of: $0, in: map) }) ?? []
        
        return "\(path.count - 1)"
    }

    static func solvePart2(input: [Int]) -> String {
        let favoriteNumber = input.first!
        let start = Pos(x: 1, y: 1)
        
        let map = generateMap(with: favoriteNumber, maxX: 100, maxY: 100)
        var reachablePositions: Set<Pos> = []
        
        for x in 0...50 {
            for y in 0...50 {
                if abs(x - 1) + abs(y - 1) > 50 { continue }
                if map[y][x] == "#" { continue }
                
                let path = aStar(start: start, goal: Pos(x: x, y: y), neighbors: { getNeighbors(of: $0, in: map) }) ?? []
                if path.isEmpty { continue }
                if path.count-1 <= 50 {
                    reachablePositions.insert(Pos(x: x, y: y))
                }
            }
        }
        
        return "\(reachablePositions.count)"
    }
    
    static func generateMap(with favoriteNumber: Int, maxX: Int, maxY: Int) -> Map {
        var map: Map = []
        for y in 0...maxY {
            var row: [Character] = []
            for x in 0...maxX {
                row.append(determineCoordinate(with: favoriteNumber, x: x, y: y))
            }
            map.append(row)
        }
        return map
    }
    
    static func determineCoordinate(with favoriteNumber: Int, x: Int, y: Int) -> Character {
        let value = x * x + 3 * x + 2 * x * y + y + y * y + favoriteNumber
        let binaryRepresentation = String(value, radix: 2)
        let onesCount = binaryRepresentation.filter{ $0 == "1" }.count
        return onesCount.isMultiple(of: 2) ? "." : "#"
    }
    
    static func getNeighbors(of pos: Pos, in map: Map) -> [Pos] {
        let neighbors: [Pos] = [
            Pos(x: pos.x + 1, y: pos.y),
            Pos(x: pos.x - 1, y: pos.y),
            Pos(x: pos.x, y: pos.y + 1),
            Pos(x: pos.x, y: pos.y - 1)
        ]
        
        return neighbors.filter {
            $0.x >= 0 && $0.y >= 0 && $0.x < map[0].count && $0.y < map.count
        }
        .filter {
            map[$0.y][$0.x] == "."
        }
    }
}
