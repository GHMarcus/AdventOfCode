//
//  Day_10.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2024/day/10

enum Day_10_2024: Solvable {
    static var day: Input.Day = .Day_10
    static var year: Input.Year = .Year_2024
    typealias ConvertedInput = Map

    struct Pos: Hashable {
        let x: Int
        let y: Int
    }
    
    class Map {
        var grid: [[Int]]
        
        init(grid: [[Int]]) {
            self.grid = grid
        }
        
        func neighbors(of pos: Pos) -> [Pos] {
            [
                Pos(x: pos.x + 1, y: pos.y),
                Pos(x: pos.x - 1, y: pos.y),
                Pos(x: pos.x, y: pos.y + 1),
                Pos(x: pos.x, y: pos.y - 1)
            ]   .filter{ $0.x >= 0 && $0.y >= 0 && $0.x < grid[0].count && $0.y < grid.count }
                .filter{ grid[$0.y][$0.x] == grid[pos.y][pos.x] + 1 }
        }
    }
    
    static func convert(input: [String]) -> ConvertedInput {
        Map(grid: input.map { Array($0).map { Int(String($0)) ?? -1 } })
    }
    
    static func solvePart1(input: ConvertedInput) -> String {
        var totalScore = 0
        var scores: Set<Pos> = []
        
        walkAlongTheTrails(for: input) { end in
            if let end = end {
                scores.insert(end)
            } else {
                totalScore += scores.count
                scores = []
            }
        }
        
        return "\(totalScore)"
    }

    static func solvePart2(input: ConvertedInput) -> String {
        var totalRating = 0
        var currentRating = 0
        
        walkAlongTheTrails(for: input) { end in
            if end != nil {
                currentRating += 1
            } else {
                totalRating += currentRating
                currentRating = 0
            }
        }
        
        return "\(totalRating)"
    }
    
    static func getTrailHeads(input: ConvertedInput) -> [Pos] {
        var trailHeads: [Pos] = []
        
        for y in 0..<input.grid.count {
            for x in 0..<input.grid[0].count {
                if input.grid[y][x] == 0 {
                    trailHeads.append(Pos(x: x, y: y))
                }
            }
        }
        
        return trailHeads
    }
    
    static func walkAlongTheTrails(for input: ConvertedInput, counting: ((Pos?) -> Void)) {
        for trailHead in getTrailHeads(input: input) {
            var pathes: [[Pos]] = [[trailHead]]
            
            while !pathes.isEmpty {
                let path = pathes.removeFirst()
                let nextPos = input.neighbors(of: path.last!)
                for next in nextPos {
                    if input.grid[next.y][next.x] == 9 {
                        counting(next)
                        continue
                    } else {
                        pathes.append(path + [next])
                    }
                }
            }
            counting(nil)
        }
    }
}
